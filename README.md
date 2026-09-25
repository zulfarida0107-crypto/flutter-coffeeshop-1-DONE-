# ☕ Flutter Coffee Shop App

Sistem Manajemen Pemesanan & Kasir (Point of Sale) Coffee Shop berbasis mobile menggunakan framework **Flutter** yang dilengkapi dengan manajemen menu, multi-item order, pencatatan transaksi pembayaran, upload desain kustom pesanan, manajemen pengguna, serta pengiriman pesan kontak.

---

## 📌 Daftar Isi
- [Tentang Aplikasi](#-tentang-aplikasi)
- [Dokumentasi & Demo](#-dokumentasi--demo)
- [Fitur Utama](#-fitur-utama)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Struktur Direktori](#-struktur-direktori)
- [Panduan Menjalankan Proyek](#-panduan-menjalankan-proyek)
  - [1. Menjalankan di Android Studio (Emulator)](#1-menjalankan-di-android-studio-emulator)
  - [2. Menjalankan via Terminal / CLI](#2-menjalankan-via-terminal--cli)
  - [3. Perintah Kontrol Saat Running (Hot Reload)](#3-perintah-kontrol-saat-running-hot-reload)
  - [4. Build APK Release](#4-build-apk-release)
- [Akun Demo & Akses](#-akun-demo--akses)

---

## 📖 Tentang Aplikasi

Aplikasi **Flutter Coffee Shop** dirancang untuk memudahkan operasional kafe dalam mengelola alur bisnis harian:
1. Membantu kasir mencatat pesanan pelanggan secara cepat dan akurat.
2. Memfasilitasi pesanan khusus (custom order) dengan fitur upload foto/desain referensi.
3. Menghitung total belanja, pembayaran tunai, dan uang kembalian secara otomatis.
4. Terintegrasi dengan database lokal (SQLite) serta arsitektur backend REST API (Spring Boot + MySQL) untuk sinkronisasi data transaksi.

---

## 📷 Dokumentasi & Demo

Berikut adalah visualisasi antarmuka aplikasi Flutter pada emulator Android:

| Fitur | Tampilan Dokumentasi | Deskripsi |
| :--- | :---: | :--- |
| **Halaman Login & Autentikasi** | <img src="docs/screenshots/ui_login.png" width="200" alt="Halaman Login"/> | Halaman autentikasi pengguna dengan proteksi sesi, validasi akun, serta tombol akses cepat role Kasir & Admin. |
| **Dashboard Menu Utama** | <img src="docs/screenshots/ui_dashboard.png" width="200" alt="Dashboard Utama"/> | Menu beranda utama (grid navigasi) yang menghubungkan pengguna ke seluruh modul operasional coffee shop. |
| **Katalog & Manajemen Menu Produk** | <img src="docs/screenshots/ui_menu_produk.png" width="200" alt="Daftar Menu Produk"/> | Menampilkan daftar menu minuman kopi, non-kopi, dan makanan beserta fitur tambah (floating button), ubah, dan hapus menu. |
| **Daftar & Pembuatan Pesanan** | <img src="docs/screenshots/ui_daftar_pesanan.png" width="200" alt="Daftar Pesanan"/> | Pencatatan pesanan kasir (Point of Sale) untuk memilih menu belanja dengan kalkulasi total harga otomatis. |
| **Kasir & Konfirmasi Pembayaran** | <img src="docs/screenshots/ui_pembayaran.png" width="200" alt="Pembayaran Pesanan"/> | Halaman kasir untuk validasi pembayaran tunai, kalkulasi uang kembalian, dan pembaruan status transaksi lunas. |
| **Desain Custom Pesanan (Kue & Cup)** | <img src="docs/screenshots/ui_desain_pesanan.png" width="200" alt="Desain Custom Pesanan"/> | Fitur unggah foto referensi pesanan khusus via kamera/galeri beserta catatan instruksi tambahan bagi barista/dapur. |
| **Manajemen Pengguna (User)** | <img src="docs/screenshots/ui_manajemen_user.png" width="200" alt="Manajemen User"/> | Pengelolaan akun pengguna internal kafe (Admin dan Kasir), penambahan akun, serta pembaruan data pengguna. |
| **Daftar Pesan Masuk & Kontak** | <img src="docs/screenshots/ui_pesan_masuk.png" width="200" alt="Pesan Kontak Masuk"/> | Kotak masuk penerimaan pesan, kritik, saran, serta form kontak dari pelanggan kafe. |

### 🗄️ Dokumentasi Arsitektur Backend & Database

| Komponen | Tampilan Dokumentasi | Deskripsi |
| :--- | :---: | :--- |
| **Endpoint Swagger / API Docs** | <img src="docs/screenshots/api_docs_postman.png" width="280" alt="API Docs Postman"/> | Dokumentasi pengetesan endpoint REST API (User, Menu, Pesanan, Desain Custom, Kontak) menggunakan Postman. |
| **Koneksi Database MySQL** | <img src="docs/screenshots/database_mysql_heidisql.png" width="280" alt="Database HeidiSQL"/> | Struktur tabel database `ta_db_coffeeshop` pada HeidiSQL: `desain_pesanan`, `menu_produk`, `pesanan`, `pesan_kontak`, `user`. |
| **Log Aktivitas Server** | <img src="docs/screenshots/server_log_console.png" width="280" alt="Log Server Console"/> | Tampilan log konsol saat server Spring Boot menerima request transaksi. |

> [!TIP]
> Semua tangkapan layar antarmuka aplikasi dan backend tersimpan di folder `docs/screenshots/` dan siap ditampilkan secara otomatis saat repositori dibuka di GitHub.

---

## ✨ Fitur Utama

- 🔐 **Autentikasi & Multi-Role Pengguna**:
  - Login dengan autentikasi berbasis pengguna (`Admin` & `Kasir`).
  - Manajemen user (Tambah, Ubah, Hapus akun kasir/admin).
  - *Session Protection*: Proteksi sesi otomatis saat aplikasi diminimalkan (background).

- 📋 **Katalog & Manajemen Menu Produk**:
  - Tampilan daftar menu kopi, non-kopi, dan camilan/snack.
  - CRUD Menu (Create, Read, Update, Delete produk beserta harga, kategori, dan deskripsi).

- 🛒 **Pencatatan Pesanan (Point of Sale)**:
  - Pembuatan tiket pesanan dengan multi-item menu.
  - Perhitungan otomatis subtotal per menu dan total harga akumulatif.
  - Pelacakan status pesanan (*Pending*, *Diproses*, *Selesai*).

- 💳 **Kasir & Konfirmasi Pembayaran**:
  - Halaman kasir untuk validasi nominal pembayaran tunai pelanggan.
  - Kalkulasi instan untuk jumlah uang kembalian.
  - Konfirmasi status pelunasan transaksi pesanan.

- 🎨 **Desain Custom Pesanan**:
  - Fitur pemesanan khusus bagi pelanggan (misal: custom latte art, topper cake khusus, atau kemasan hampers).
  - Integrasi kamera & galeri (`image_picker`) untuk mengunggah foto desain/referensi.
  - Catatan instruksi khusus untuk barista/dapur.

- ✉️ **Pesan Masuk & Kontak**:
  - Formulir kirim feedback, kritik, saran, atau pertanyaan dari pelanggan.
  - Dashboard pesan kontak masuk untuk pengelola.

---

## 🛠 Tech Stack & Dependencies

- **Frontend / Client**: [Flutter](https://flutter.dev/) (Dart 3.x)
- **Local Storage / Persistence**:
  - `sqflite`: Penyimpanan basis data relasional offline-first
  - `shared_preferences`: Manajemen sesi pengguna & status navigasi
- **Device Features**:
  - `image_picker`: Akses galeri dan kamera untuk upload foto desain
  - `url_launcher`: Membuka tautan eksternal
- **Backend / API (Opsional / Integrasi)**:
  - Java Spring Boot REST API
  - MySQL (`ta_db_coffeeshop`) dikelola via HeidiSQL / phpMyAdmin

---

## 🚀 Panduan Menjalankan Proyek

### 1. Menjalankan di Android Studio (Emulator)

1. Buka software **Android Studio**.
2. Buka menu **Tools** > **Device Manager** (atau klik ikon ponsel di toolbar samping kanan).
3. Pada daftar Virtual Device, klik tombol **Play** (▶️) pada emulator pilihan Anda (misalnya `Medium Phone API 36` atau `Pixel`).
4. Tunggu beberapa detik hingga sistem Android pada emulator menyala dan masuk ke layar beranda (*Home Screen*).
5. Buka proyek ini di Android Studio atau VS Code.
6. Pada *Device Selector* (dropdown perangkat), pilih nama emulator yang sedang berjalan.
7. Tekan tombol **Run** (ikon segitiga hijau ▶️) atau tekan shortcut `Shift + F10` (Android Studio) / `F5` (VS Code).

---

### 2. Menjalankan via Terminal / CLI

Pastikan Flutter SDK sudah terpasang dan dikenali di PATH sistem Anda.

1. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

2. **Cek Perangkat yang Aktif**:
   ```bash
   flutter devices
   ```
   *Contoh output yang menunjukkan emulator siap:*
   ```text
   sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 16 (API 36)
   ```

3. **Jalankan Aplikasi ke Emulator**:
   ```bash
   flutter run -d emulator-5554
   ```
   *(Atau cukup ketik `flutter run` jika hanya ada satu perangkat emulator aktif)*.

4. Tunggu hingga proses build `assembleDebug` selesai dan aplikasi muncul di layar emulator.

---

### 3. Perintah Kontrol Saat Running (Hot Reload)

Ketika aplikasi sedang berjalan melalui terminal, gunakan tombol berikut:
- **`r`** (huruf kecil) : **Hot Reload** (memperbarui perubahan kode UI secara instan tanpa restart).
- **`R`** (huruf kapital) : **Hot Restart** (mereset state dan menjalankan ulang aplikasi dari awal).
- **`h`** : Menampilkan daftar bantuan shortcut di terminal.
- **`q`** : Menghentikan aplikasi yang sedang berjalan.

---

### 4. Build APK Release

Untuk menghasilkan file APK siap pasang di perangkat fisik Android:
```bash
flutter build apk --release
```
File APK keluaran akan tersimpan di:
```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 Akun Demo & Akses

| Role | Username | Password Default | Keterangan |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Akses 

*(Kredensial dapat disesuaikan atau didaftarkan melalui menu registrasi/manajemen user pada aplikasi).*
