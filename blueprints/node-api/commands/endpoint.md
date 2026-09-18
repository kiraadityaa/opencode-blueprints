---
description: Scaffold a new API endpoint following project conventions.
agent: build
---

Buat endpoint API baru sesuai argumen (wajib): resource/method, misalnya `GET /users/:id`.

1. Tentukan route module yang tepat (satu file per resource) dan daftarkan di entry point jika perlu.
2. Definisikan schema zod untuk body/query/params sesuai method.
3. Tulis handler async dengan error handling meneruskan ke central error handler.
4. Kembalikan status code yang tepat (200/201/204/4xx/5xx) dan bentuk response yang konsisten dengan endpoint lain.
5. Tambahkan test route (supertest-style) untuk happy path + error case.
6. Jangan mencatat (log) data sensitif; jangan mengubah env/config tanpa konfirmasi.
7. Verifikasi: `npm run typecheck` dan `npm test` hijau.

Argumen: $ARGUMENTS