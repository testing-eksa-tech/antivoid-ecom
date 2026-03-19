# Antivoid E-Commerce Premium

Antivoid adalah aplikasi e-commerce modern berbasis Ruby yang dirancang dengan estetika **Glassmorphism** dan fitur lengkap untuk kebutuhan bisnis online masa kini. Aplikasi ini menggunakan framework minimalis (Rack) untuk performa maksimal dan kemudahan kustomisasi.

## ✨ Fitur Utama (Pelanggan)

- **🛒 Sistem Belanja Reaktif**: Keranjang belanja dengan pembaruan unit barang instan dan perhitungan total otomatis.
- **💳 Integrated Payment Gateway**: Dukungan pembayaran otomatis melalui **Xendit** (E-Wallet, Virtual Account, QRIS, dll).
- **🔐 Secure Checkout**: Proses pembayaran yang aman dengan verifikasi stok real-time dan kewajiban autentikasi.
- **❤️ Personalized Wishlist**: Simpan produk favorit Anda ke dalam daftar keinginan pribadi.
- **⭐ Review & Rating Produk**: Berikan masukan dan penilaian pada produk yang telah dibeli.
- **📱 Akun & Riwayat Pesanan**: Lacak status pesanan secara real-time dan kelola profil pengiriman Anda.
- **🔍 Pencarian & Filter Canggih**: Temukan produk dengan mudah melalui fitur pencarian dan kategori yang terorganisir.
- **📲 Integrasi WhatsApp**: Hubungi admin secara instan melalui formulir kontak yang terintegrasi WhatsApp.
- **📧 Email Receipt Otomatis**: Terima struk belanja profesional langsung di email Anda setelah pembayaran terkonfirmasi.

## 🛠️ Panel Admin (CMS)

- **📊 Dashboard Analitik**: Statistik penjualan dan performa toko secara real-time.
- **📦 Manajemen Produk Complete**: Tambah, edit, dan hapus produk dengan integrasi Cloudinary untuk optimasi gambar.
- **📂 Manajemen Kategori**: Atur struktur katalog produk dengan mudah.
- **🖼️ Banner & Promo**: Kelola slider promo pada halaman beranda secara dinamis.
- **📋 Manajemen Pesanan**: Pantau pesanan masuk, perbarui status pengiriman secara otomatis setelah pembayaran.
- **📤 Export Data**: Ekspor data pesanan ke format CSV untuk kebutuhan akuntansi dan pelaporan.

## 🚀 SEO & Optimasi Teknis

- **📈 Google Ready**: Dilengkapi dengan `sitemap.xml` dan `robots.txt` otomatis.
- **💎 Structured Data (JSON-LD)**: Dukungan rich snippets untuk tampilan produk yang lebih menonjol di hasil pencarian.
- **Social Sharing**: Meta tags Open Graph (OG) dioptimalkan untuk berbagi di media sosial.
- **⚡ Ultra Fast Performance**: Menggunakan Ruby Rack + Puma untuk waktu pemuatan halaman yang sangat cepat.
- **🖼️ Asset Optimization**: Cloudinary CDN untuk pengiriman gambar responsif dan pembersihan otomatis storage.

## 💻 Teknologi

- **Core**: [Ruby 3.3+](https://www.ruby-lang.org/) dengan [Rack](https://github.com/rack/rack)
- **Server**: [Puma](https://puma.io/)
- **Database**: [MongoDB Atlas](https://www.mongodb.com/atlas)
- **Payment Gateway**: [Xendit API](https://www.xendit.co/)
- **Storage & CDN**: [Cloudinary](https://cloudinary.com/)
- **Email Gateway**: [Brevo API](https://www.brevo.com/)
- **Frontend**: [Tailwind CSS](https://tailwindcss.com/), [Glassmorphism UI](https://glassmorphism.com/), [Lucide Icons](https://lucide.dev/), [Animate.css](https://animate.style/)
- **Keamanan**: BCrypt Password Hashing, JWT-based Sessions.

## 📦 Instalasi

1. **Clone repositori**:
   ```bash
   git clone https://github.com/Eksa-Tech/antivoid-ecom.git
   cd antivoid-ecom
   ```

2. **Instal dependensi**:
   ```bash
   bundle install
   ```

3. **Konfigurasi Environment**:
   Salin `.env.example` menjadi `.env` dan isi kredensial Anda:
   ```bash
   cp .env.example .env
   ```
   Pastikan Anda mengisi:
   - `MONGODB_URI`: Koneksi MongoDB Atlas.
   - `CLOUDINARY_URL`: API Cloudinary Environment.
   - `BREVO_API_KEY`: API Key untuk pengiriman email.
   - **Xendit Config**:
     - `XENDIT_SECRET_KEY`: Secret API Key dari Xendit Dashboard.
     - `XENDIT_CALLBACK_TOKEN`: Verification token untuk webhook.
   - `JWT_SECRET`: Secret key untuk enkripsi session.
   - `ADMIN_EMAIL`: Email login admin.
   - `ADMIN_PASSWORD`: Password login admin.

4. **Jalankan Aplikasi**:
   ```bash
   rackup
   ```

## 🛠️ Struktur Proyek

- `app/models/`: Logika data (Product, Category, Order, User, Review, Banner).
- `app/views/`: Template HTML dengan ERB dan Glassmorphism styling.
- `app/controllers/`: Logika bisnis (Auth, Admin, Shop).
- `app/router.rb`: Pengatur rute aplikasi (Routing & Webhook Handler).
- `app/utils/`: Helper fungsional (Database, Auth, Cloudinary, Email, Xendit API).

## 📄 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).