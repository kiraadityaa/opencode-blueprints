#!/usr/bin/env bash
#
# opencode-blueprints — Per-project OpenCode setups, one per stack
# https://github.com/kiraadityaa/opencode-blueprints
#
set -euo pipefail

# ─── Defaults ──────────────────────────────────────────────────────
REPO_URL="https://github.com/kiraadityaa/opencode-blueprints"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || echo "$HOME")"
VERSION_FILE="${SCRIPT_DIR}/VERSION"
VERSION="$(cat "${VERSION_FILE}" 2>/dev/null || echo "0.0.0")"
CACHE_DIR="${OPENCODE_BLUEPRINTS_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/opencode-blueprints}"
TARGET_DIR="."
WRITE_ROOT=false
DRY_RUN=false
FORCE=false
NO_AGENTS=false
NO_COMMANDS=false
VERBOSE=false

# ─── Colors ────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Helpers ───────────────────────────────────────────────────────
info()  { echo -e "${BLUE}▸${NC} $*"; }
ok()    { echo -e "${GREEN}✓${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
err()   { echo -e "${RED}✗${NC} $*" >&2; }
debug() { if $VERBOSE; then echo -e "${CYAN}[debug]${NC} $*"; fi; }
die()   { err "$@"; exit 1; }

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

confirm() {
    local msg="${1:-Continue?}"
    if $DRY_RUN; then return 0; fi
    read -rp "$(echo -e "${YELLOW}?${NC} ${msg} [y/N] ")" answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

run() {
    if $DRY_RUN; then
        echo -e "  ${CYAN}[dry-run]${NC} $*"
        return 0
    fi
    if $VERBOSE; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

meta_get() { # file key → value (safe: keys are word chars)
    sed -n "s/^${2}: *//p" "$1" | head -n 1
}

# ─── Usage ─────────────────────────────────────────────────────────
usage() {
    cat <<'EOF'
opencode-blueprints — Per-project OpenCode setups, one per stack

Usage:
  blueprint.sh <command> [OPTIONS]

Commands:
  list                 List available blueprints
  show <name>          Show details of a blueprint
  init <name>          Apply a blueprint into .opencode/ of the current project
  update               Refresh the blueprint catalog from GitHub
  --version            Print version and exit
  --help               Show this help

init options:
  --dir <path>         Target project directory (default: current dir)
  --root               Also write AGENTS.md to the project root
  --no-agents          Skip stack agents
  --no-commands        Skip stack commands
  --force              Overwrite existing .opencode (backs up first)
  --dry-run            Preview actions without making changes
  --verbose            Show all commands

Examples:
  blueprint.sh list
  blueprint.sh show ts-react
  blueprint.sh init ts-react
  blueprint.sh init python --dir ../my-project --root
  blueprint.sh init node-api --no-commands --dry-run
EOF
    exit 0
}

init_usage() {
    cat <<'EOF'
init — apply a blueprint into .opencode/

Usage:
  blueprint.sh init <name> [OPTIONS]

Options:
  --dir <path>         Target project directory (default: current dir)
  --root               Also write AGENTS.md to the project root
  --no-agents          Skip stack agents
  --no-commands        Skip stack commands
  --force              Overwrite existing .opencode (backs up first)
  --dry-run            Preview actions without making changes
  --verbose            Show all commands
EOF
    exit 0
}

# ─── Blueprint resolution ──────────────────────────────────────────
download_blueprints() {
    need_cmd curl
    info "Downloading blueprint catalog from GitHub..."
    local tmpdir
    tmpdir="$(mktemp -d)"
    run curl -fsSL "${REPO_URL}/archive/refs/heads/main.tar.gz" \
        | tar xz -C "$tmpdir" --strip-components=1
    mkdir -p "${CACHE_DIR}"
    run cp -a "${tmpdir}/blueprints" "${CACHE_DIR}/"
    rm -rf "$tmpdir"
    ok "Cached at ${CACHE_DIR}/blueprints"
}

resolve_blueprint_root() {
    local local_dir="${SCRIPT_DIR}/blueprints"
    if [ -d "$local_dir" ]; then
        BLUEPRINTS_DIR="$local_dir"
        debug "Using local blueprints: ${BLUEPRINTS_DIR}"
        return 0
    fi
    if [ -d "${PWD}/blueprints" ]; then
        BLUEPRINTS_DIR="${PWD}/blueprints"
        debug "Using blueprints from current dir: ${BLUEPRINTS_DIR}"
        return 0
    fi
    if [ -d "${CACHE_DIR}/blueprints" ]; then
        BLUEPRINTS_DIR="${CACHE_DIR}/blueprints"
        debug "Using cached blueprints: ${BLUEPRINTS_DIR}"
        return 0
    fi
    download_blueprints
    BLUEPRINTS_DIR="${CACHE_DIR}/blueprints"
}

find_blueprint() {
    local name="$1"
    if [ -d "${BLUEPRINTS_DIR}/${name}" ]; then
        BPDIR="${BLUEPRINTS_DIR}/${name}"
        return 0
    fi
    local dir n
    for dir in "${BLUEPRINTS_DIR}"/*/; do
        [ -f "${dir}/blueprint.meta" ] || continue
        n="$(meta_get "${dir}/blueprint.meta" name)"
        if [ -n "$n" ] && { [ "$n" = "$name" ] || meta_has_alias "${dir}/blueprint.meta" "$name"; }; then
            BPDIR="${dir%/}"
            return 0
        fi
    done
    return 1
}

meta_has_alias() {
    local aliases
    aliases="$(meta_get "$1" aliases)"
    [[ " ${aliases//,/ } " == *" $2 "* ]]
}

# ─── Commands ──────────────────────────────────────────────────────
cmd_list() {
    resolve_blueprint_root
    [ -d "$BLUEPRINTS_DIR" ] || die "No blueprints found"
    info "Available blueprints:"
    echo ""
    local dir name desc
    for dir in "${BLUEPRINTS_DIR}"/*/; do
        [ -f "${dir}/blueprint.meta" ] || continue
        name="$(meta_get "${dir}/blueprint.meta" name)"
        desc="$(meta_get "${dir}/blueprint.meta" description)"
        printf "  ${GREEN}%-14s${NC} %s\n" "${name:-?}" "${desc:-}"
    done
    echo ""
    info "Apply one: blueprint.sh init <name>"
}

cmd_show() {
    local name="${1:-}"
    [ -n "$name" ] || die "show requires a blueprint name: blueprint.sh show <name>"
    resolve_blueprint_root
    find_blueprint "$name" || die "Blueprint not found: $name (run 'blueprint.sh list')"
    local meta="${BPDIR}/blueprint.meta"
    local name2 desc stack effort keywords aliases
    name2="$(meta_get "$meta" name)"; desc="$(meta_get "$meta" description)"
    stack="$(meta_get "$meta" stack)"; effort="$(meta_get "$meta" effort)"
    keywords="$(meta_get "$meta" keywords)"; aliases="$(meta_get "$meta" aliases)"

    echo ""
    echo -e "  ${BOLD}${name2}${NC} — ${desc}"
    [ -n "$stack" ]    && echo -e "  Stack:   ${stack}"
    [ -n "$effort" ]   && echo -e "  Effort:  ${effort}"
    [ -n "$keywords" ] && echo -e "  Tags:    ${keywords}"
    [ -n "$aliases" ]  && echo -e "  Aliases: ${aliases}"
    echo ""
    if [ -f "${BPDIR}/README.md" ]; then
        info "README:"
        sed -n '1,40p' "${BPDIR}/README.md"
        echo ""
    fi
    info "Apply: blueprint.sh init ${name2}"
}

cmd_init() {
    local name=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dir)        TARGET_DIR="${2:?--dir requires a path}"; shift 2 ;;
            --dir=*)      TARGET_DIR="${1#*=}"; shift ;;
            --root)       WRITE_ROOT=true; shift ;;
            --no-agents)  NO_AGENTS=true; shift ;;
            --no-commands) NO_COMMANDS=true; shift ;;
            --force)      FORCE=true; shift ;;
            --dry-run)    DRY_RUN=true; shift ;;
            --verbose)    VERBOSE=true; shift ;;
            --help|-h)    init_usage ;;
            -*)           die "Unknown init option: $1 (use --help)" ;;
            *)            name="$1"; shift ;;
        esac
    done
    [ -n "$name" ] || die "init requires a blueprint name: blueprint.sh init <name>"

    need_cmd bash
    resolve_blueprint_root
    find_blueprint "$name" || die "Blueprint not found: $name (run 'blueprint.sh list')"

    # Validate blueprint structure
    [ -f "${BPDIR}/opencode.json" ] || die "Blueprint ${name}: missing opencode.json"
    [ -f "${BPDIR}/AGENTS.md" ]     || die "Blueprint ${name}: missing AGENTS.md"

    local meta desc
    meta="${BPDIR}/blueprint.meta"
    desc="$(meta_get "$meta" description 2>/dev/null || true)"

    [ -d "$TARGET_DIR" ] || die "Target directory does not exist: ${TARGET_DIR}"

    local target="${TARGET_DIR%/}/.opencode"
    info "Applying blueprint '${name}': ${desc:-$name}"
    debug "Source:      ${BPDIR}"
    debug "Target:      ${target}"
    $WRITE_ROOT && debug "Root AGENTS.md: enabled"

    # Conflict handling
    if [ -f "${target}/opencode.json" ]; then
        if $FORCE; then
            local ts dest
            ts="$(date +%Y%m%d_%H%M%S)"
            dest="${TARGET_DIR%/}/.opencode.bak.${ts}"
            info "Backing up existing .opencode → ${dest}"
            run cp -a "$target" "$dest"
        elif ! confirm "Existing .opencode found at ${target} — overwrite?"; then
            die "Aborted. Use --force to overwrite."
        fi
    fi

    # Deploy
    run mkdir -p "$target" "${target}/agents" "${target}/commands"
    run cp "${BPDIR}/opencode.json" "${target}/opencode.json"
    run cp "${BPDIR}/AGENTS.md" "${target}/AGENTS.md"

    local agents_dir="${BPDIR}/agents" commands_dir="${BPDIR}/commands"
    if ! $NO_AGENTS && [ -d "$agents_dir" ] && [ -n "$(ls -A "$agents_dir" 2>/dev/null)" ]; then
        info "Deploying agents..."
        run cp "$agents_dir"/*.md "$target/agents/"
    fi
    if ! $NO_COMMANDS && [ -d "$commands_dir" ] && [ -n "$(ls -A "$commands_dir" 2>/dev/null)" ]; then
        info "Deploying commands..."
        run cp "$commands_dir"/*.md "$target/commands/"
    fi

    # Optional root AGENTS.md
    if $WRITE_ROOT; then
        if [ -f "${TARGET_DIR%/}/AGENTS.md" ] && ! $FORCE; then
            warn "AGENTS.md exists at ${TARGET_DIR} — kept (use --force to overwrite)"
        else
            run cp "${BPDIR}/AGENTS.md" "${TARGET_DIR%/}/AGENTS.md"
        fi
    fi

    ok "Blueprint '${name}' applied → ${target}"

    echo ""
    echo -e "  ${BOLD}Next:${NC}"
    echo -e "    1. ${CYAN}opencode${NC} — launch in this project dir"
    echo -e "    2. ${CYAN}/agents${NC}, ${CYAN}/commands${NC} — use the stack tools"
    echo -e "    3. Review ${CYAN}${target}/opencode.json${NC} to tune permissions"
}

cmd_update() {
    need_cmd curl
    download_blueprints
    ok "Blueprint catalog is up to date"
}

# ─── Main ──────────────────────────────────────────────────────────
main() {
    local cmd="${1:-help}"
    shift || true

    echo ""
    echo -e "${BOLD}opencode-blueprints${NC} — v${VERSION} — Per-project OpenCode setups"
    echo -e "${CYAN}${REPO_URL}${NC}"
    echo ""

    case "$cmd" in
        list)          cmd_list ;;
        show)          cmd_show "${1:-}" ;;
        init)          cmd_init "$@" ;;
        update)        cmd_update ;;
        --version|-V)  echo "opencode-blueprints ${VERSION}" && exit 0 ;;
        --help|-h|help) usage ;;
        *)             usage ;;
    esac
}

main "$@"