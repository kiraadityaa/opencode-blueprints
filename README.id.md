<div align="center">

# ⌘ opencode-blueprints

**Setup OpenCode per-proyek — config `.opencode/` siap pakai, satu per stack.**

Satu perintah, dan OpenCode kamu langsung dapat konfigurasi yang disesuaikan stack untuk proyek yang sedang dikerjakan — permission, AGENTS.md, agent, dan command, semuanya di dalam `.opencode/`.

[![Shellcheck](https://img.shields.io/github/actions/workflow/status/kiraadityaa/opencode-blueprints/ci.yml?branch=main&label=CI&logo=github)](https://github.com/kiraadityaa/opencode-blueprints/actions)
[![License](https://img.shields.io/github/license/kiraadityaa/opencode-blueprints?color=blue)](LICENSE)
[![Release](https://img.shields.io/github/v/release/kiraadityaa/opencode-blueprints?logo=github)](https://github.com/kiraadityaa/opencode-blueprints/releases)
[![Repo](https://img.shields.io/badge/opencode-setup--opencode-3b3b3b?logo)](https://github.com/kiraadityaa/setup-opencode)

[English](README.md) · **Bahasa Indonesia**

</div>

---

## Apa ini?

OpenCode membaca config **global** dari `~/.config/opencode/` dan config **proyek** dari `.opencode/` di samping proyek kamu. Setup global ([setup-opencode](https://github.com/kiraadityaa/setup-opencode)) cocok untuk *di mana saja*. Tapi tiap proyek butuh aturan yang berbeda:

| | Global (`setup-opencode`) | Per-proyek (**repo ini**) |
|---|---|---|
| Dipasang ke | `~/.config/opencode/` | `.opencode/` di dalam proyek kamu |
| Cakupan | Semua proyek di mesin | Hanya repo tempat kamu memasangnya |
| Cocok untuk | Default seluruh mesin, MCP, skills | Permission, agent, command spesifik stack |
| Contoh | sudo allow, aturan git, MCP memory | `npm publish: deny` untuk frontend, izin `uv` untuk Python |

**opencode-blueprints** menyediakan config proyek siap pakai yang di-tune per stack. Pilih satu, jalankan satu perintah, selesai.

## Blueprint yang tersedia

| Blueprint | Stack | Yang diterapkan |
|---|---|---|
| **ts-react** | TypeScript + React (Vite/Next) | npm test/build/lint/typecheck allow, dev/install ask, publish deny |
| **node-api** | API Node.js (Express/Fastify) | sama seperti di atas + `npm start` ask |
| **python** | Python (uv/pip) + pytest/ruff/mypy | uv/pytest/ruff/mypy allow, pip install ask |

Setiap blueprint membawa `opencode.json`, `AGENTS.md`, sebuah **agent** (mis. `react-reviewer`), dan sebuah **command** (mis. `/component`).

## Mulai cepat

Butuh: `bash`, `curl` (untuk blueprint remote), git.

Clone dan inisialisasi — jalankan di dalam repo proyek yang ingin dikonfigurasi:

```bash
git clone https://github.com/kiraadityaa/opencode-blueprints.git
cd opencode-blueprints && bash blueprint.sh init ts-react   # atau: node-api, python
```

Atau tanpa clone — script otomatis mengambil katalog blueprint saat pertama dijalankan:

```bash
cd /path/ke/proyek-kamu
curl -fsSL https://github.com/kiraadityaa/opencode-blueprints/raw/main/blueprint.sh | bash -s init python
```

Itu saja. Deploy tidak menghapus apa pun di mesin kamu — hanya membuat `.opencode/` di dalam proyek saat ini.

> **Posisi:** gunakan `setup-opencode` untuk config seluruh mesin, dan **opencode-blueprints** per proyek. Keduanya saling melengkapi — aturan proyek diterapkan di atas config global kamu.

## Referensi CLI

```
blueprint.sh list                 Daftar blueprint yang tersedia
blueprint.sh show <name>          Lihat detail sebuah blueprint
blueprint.sh init <name>          Terapkan blueprint ke .opencode/ proyek saat ini
blueprint.sh update               Perbarui katalog blueprint dari GitHub
blueprint.sh --version            Cetak versi lalu keluar
blueprint.sh --help               Tampilkan bantuan ini
```

### Opsi `init`

| Opsi | Keterangan |
|---|---|
| `--dir <path>` | Direktori proyek tujuan (default: direktori saat ini) |
| `--root` | Sekaligus menulis `AGENTS.md` ke root proyek |
| `--no-agents` | Lewati agent bawaan stack |
| `--no-commands` | Lewati command bawaan stack |
| `--force` | Tindih `.opencode` yang ada (di-backup ke `.opencode.bak.<ts>` dulu) |
| `--dry-run` | Pratinjau aksi tanpa mengubah apa pun |
| `--verbose` | Tampilkan setiap perintah yang dijalankan |

### Yang dibuat `init`

```
proyek-kamu/
└── .opencode/
    ├── opencode.json     # config proyek: AGENTS.md + permission stack
    ├── AGENTS.md         # konvensi stack + rules for agents
    ├── agents/           # mis. react-reviewer.md, api-reviewer.md
    └── commands/         # mis. component.md, endpoint.md
```

`opencode.json` mengatur `"instructions": ["AGENTS.md"]` (diresolusi relatif terhadap `.opencode/`) sehingga OpenCode memuat aturan stack otomatis.

## Menambahkan blueprint

Blueprint berada di `blueprints/`. Masing-masing berupa folder:

```
blueprints/<name>/
├── blueprint.meta       # name, description, stack, effort, keywords, aliases
├── opencode.json        # config proyek JSON valid (divalidasi di CI)
├── AGENTS.md            # konvensi stack + rules for agents
├── agents/*.md          # agent bawaan stack (opsional)
├── commands/*.md        # command bawaan stack (opsional)
└── README.md            # deskripsi singkat untuk manusia
```

Deploy ke mesin ini aman sejak desain:

- Script **tidak pernah menyentuh** config global `~/.config/opencode/` kamu.
- Ia hanya menulis di dalam proyek tujuan (`.opencode/`, plus `AGENTS.md` di root hanya dengan `--root`).
- `.opencode` yang ada hanya ditindih dengan `--force`, setelah backup ber-timestamp.

## FAQ

<details>
<summary><b>Bagaimana cara membatalkan blueprint?</b></summary>

```bash
rm -rf .opencode
```

Config global OpenCode kamu tidak tersentuh, jadi tidak ada hal lain yang terpengaruh.

</details>

<details>
<summary><b>Bagaimana kalau `.opencode/opencode.json` sudah ada?</b></summary>

`init` akan bertanya sebelum menindih. Dengan `--force`, folder lama di-backup ke `.opencode.bak.<timestamp>` lalu di-deploy ulang.

</details>

<details>
<summary><b>Apakah blok permission menggantikan aturan global saya?</b></summary>

Tidak. Config proyek melengkapi config global — OpenCode menggabungkannya. Blueprint hanya menambah aturan yang disesuaikan stack di atasnya (mis. `npm publish: deny`).

</details>

<details>
<summary><b>Bisa dipakai tanpa clone?</b></summary>

Bisa — varian pipa `curl … | bash -s init <nama>` otomatis mengunduh dan meng-cache katalog ke `~/.cache/opencode-blueprints/`. Jalankan `update` untuk menyegarkannya.

</details>

## Struktur proyek

```
.
├── blueprint.sh          # CLI-nya (bash, tanpa dependensi)
├── blueprints/
│   ├── ts-react/         # TypeScript + React (Vite/Next)
│   ├── node-api/         # API Node.js (Express/Fastify)
│   └── python/           # Python (uv/pip)
├── VERSION               # versi saat ini (SemVer)
├── .github/workflows/    # CI: shellcheck + validasi + smoke test init
└── LICENSE               # MIT
```

## Pengembangan

Lihat [CONTRIBUTING.md](CONTRIBUTING.md). Setiap perubahan pada `blueprints/*` atau `blueprint.sh` divalidasi di CI: `shellcheck` pada script, validitas JSON setiap `opencode.json`, dan smoke test `init` end-to-end.

## Lisensi

[MIT](LICENSE) © kazehaya aditya