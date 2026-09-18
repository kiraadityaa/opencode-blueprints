---
description: Scaffold a new React component following project conventions.
agent: build
---

Buat komponen React baru sesuai argumen berikut (wajib): nama komponen, dan opsional props.

1. Letakkan di `src/components/<Nama>.tsx` mengikuti struktur folder yang ada.
2. Definisikan interface props yang diketik dan export bersama komponen.
3. Gunakan pola yang konsisten dengan komponen lain di proyek (function component, nama hook sesuai aturan).
4. Jika ada mock/sample data, jadikan prop opsional dengan default — jangan hardcode di dalam komponen.
5. Jangan mengubah konfigurasi build, ESLint, atau menambah dependency tanpa konfirmasi.
6. Verifikasi: `npm run typecheck` dan `npm run lint` bersih.

Argumen: $ARGUMENTS