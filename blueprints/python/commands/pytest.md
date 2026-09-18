---
description: Run the Python test suite and report failures.
agent: build
---

Jalankan test Python sesuai alat yang tersedia di proyek:

1. Cek `pyproject.toml` untuk tooling test (pytest) dan penentu kebutuhan.
2. Jalankan suite: `uv run pytest` jika `uv` tersedia, selain itu `.venv/bin/python -m pytest` atau `python3 -m pytest`.
3. Jalankan juga `ruff check .` (lint) dan `mypy .` (type) jika dikonfigurasi di proyek.
4. Jika ada test gagal: analisis akar masalah, perbaiki minimal, jalankan ulang test yang gagal sampai hijau.
5. Jangan install dependency baru tanpa konfirmasi; jangan modifikasi `pyproject.toml` kecuali diperlukan.

Jika argumen diberikan, jalankan hanya test yang cocok: $ARGUMENTS