# Panduan Konfigurasi API - Antivoid E-Commerce

Dokumen ini menjelaskan langkah-langkah untuk mendapatkan dan memasang API Key yang dibutuhkan agar fitur-fitur di aplikasi Antivoid berjalan dengan sempurna.

---

## 1. MongoDB Atlas (Database)
Digunakan untuk menyimpan data produk, pengguna, dan pesanan.

*   **Daftar**: [mongodb.com/atlas](https://www.mongodb.com/atlas)
*   **Langkah**:
    1.  Buat Cluster baru (pilih paket *Free*).
    2.  Pilih **Database Access** -> Tambahkan user baru (ingat username & password).
    3.  Pilih **Network Access** -> Tambahkan IP `0.0.0.0/0` (agar bisa diakses dari mana saja).
    4.  Pilih **Clusters** -> **Connect** -> **Connect your application**.
    5.  Salin Connection String-nya.
*   **.env**: `MONGODB_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/e-commerce`

---

## 2. Cloudinary (Image Storage)
Digunakan untuk menyimpan gambar produk secara cloud.

*   **Daftar**: [cloudinary.com](https://cloudinary.com/)
*   **Langkah**:
    1.  Masuk ke Dashboard.
    2.  Cari bagian **API Environment variable**.
    3.  Salin URL yang berawalan `cloudinary://`.
*   **.env**: `CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME`

---

## 3. Brevo / Sendinblue (Email Gateway)
Digunakan untuk mengirim struk belanja dan notifikasi admin via email.

*   **Daftar**: [brevo.com](https://www.brevo.com/)
*   **Langkah**:
    1.  Masuk ke menu **SMTP & API**.
    2.  Pilih tab **API Keys**.
    3.  Klik **Generate a new API key** dan beri nama "Antivoid".
    4.  Salin kodenya.
*   **.env**: `BREVO_API_KEY=xkeysib-your-key-here`
*   Jangan lupa isi `SENDER_EMAIL` & `SENDER_NAME` di `.env` agar email pengirim valid.

---

## 4. Xendit (Payment Gateway)
Digunakan untuk menerima pembayaran otomatis (QRIS, VA, E-Wallet).

*   **Daftar**: [xendit.co](https://www.xendit.co/)
*   **Langkah**:
    1.  Masuk ke Dashboard (disarankan gunakan *Test Mode* terlebih dahulu).
    2.  Pilih **Settings** -> **Developers** -> **API Keys**.
    3.  Generate **Secret Key** dengan izin *Read/Write* untuk Invoices.
    4.  Pilih **Settings** -> **Developers** -> **Callbacks**.
    5.  Cari **Callback Verification Token** dan salin kodenya.
*   **.env**:
    *   `XENDIT_SECRET_KEY=xnd_development_...`
    *   `XENDIT_CALLBACK_TOKEN=your_token_here`

### Pemasangan Webhook (PENTING)
Agar status pesanan berubah otomatis menjadi **Paid**, Anda harus mendaftarkan URL webhook di dashboard Xendit (Menu Callbacks -> Invoices):
*   **URL**: `https://domain-anda.com/webhooks/xendit`

---

## 🔐 Keamanan (JWT Secret)
Digunakan untuk mengamankan session login pengguna.

*   **Cara Buat**: Jalankan perintah ini di terminal:
    ```bash
    ruby -e "require 'securerandom'; puts SecureRandom.hex(32)"
    ```
*   **.env**: `JWT_SECRET=hasil_random_hex_tadi`

---

## 📝 Ringkasan Isi .env
Pastikan file `.env` Anda terlihat seperti ini:

```env
MONGODB_URI=...
CLOUDINARY_URL=...
BREVO_API_KEY=...
SENDER_EMAIL=...
SENDER_NAME=...
JWT_SECRET=...
ADMIN_EMAIL=...
ADMIN_PASSWORD=...
XENDIT_SECRET_KEY=...
XENDIT_CALLBACK_TOKEN=...
BASE_URL=...
WHATSAPP_NUMBER=...
PORT=9292
```
