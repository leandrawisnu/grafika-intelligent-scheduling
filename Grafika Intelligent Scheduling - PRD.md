# Product Requirements Document (PRD)

## Nama Project
**Grafika Intelligent Scheduling**

---

# 1. Overview

## Deskripsi

Grafika Intelligent Scheduling merupakan platform manajemen jadwal sekolah berbasis web yang dirancang untuk membantu proses penyusunan, sinkronisasi, dan publikasi jadwal pelajaran di sekolah, khususnya SMK.

Sistem ini berfokus pada penyelesaian salah satu permasalahan utama dalam penyusunan jadwal, yaitu bentrok jadwal guru yang sering terjadi saat proses sinkronisasi antar jurusan. Dengan memanfaatkan Artificial Intelligence (AI), sistem mampu mendeteksi potensi konflik, memberikan rekomendasi penyelesaian, serta membantu kurikulum mengambil keputusan dengan lebih cepat dan akurat.

---

## Latar Belakang

Pada banyak sekolah, khususnya SMK, proses penyusunan jadwal dilakukan secara bertahap.

Masing-masing jurusan terlebih dahulu menyusun jadwal berdasarkan mata pelajaran tanpa menentukan guru pengajar. Setelah seluruh jurusan selesai membuat draft jadwal, bagian kurikulum akan melakukan plotting guru ke setiap mata pelajaran, kemudian melakukan sinkronisasi seluruh jadwal.

Pada tahap sinkronisasi inilah sering terjadi berbagai konflik, seperti:

- Guru mengajar di dua kelas pada waktu yang sama.
- Guru melebihi batas jam mengajar.
- Guru memiliki hari yang seharusnya menjadi hari piket atau hari libur.
- Ruangan digunakan oleh lebih dari satu kelas pada waktu yang sama.
- Perubahan jadwal pada satu jurusan dapat menyebabkan konflik baru pada jurusan lainnya.

Proses penyelesaian konflik tersebut masih dilakukan secara manual sehingga membutuhkan waktu yang lama dan berisiko tinggi terhadap human error.

---

## Tujuan

Membangun platform yang mampu membantu sekolah dalam:

- Mengelola data akademik yang berkaitan dengan penyusunan jadwal.
- Mempermudah proses penyusunan jadwal setiap jurusan.
- Membantu bagian kurikulum melakukan sinkronisasi jadwal.
- Mengurangi konflik jadwal menggunakan bantuan AI.
- Mempercepat proses publikasi jadwal kepada guru dan siswa.

---

# 2. Existing Workflow

## Alur Saat Ini

1. Admin Jurusan membuat jadwal berdasarkan mata pelajaran.
2. Jadwal belum memiliki guru pengajar.
3. Bagian kurikulum melakukan plotting guru.
4. Kurikulum melakukan sinkronisasi seluruh jurusan.
5. Ditemukan bentrok jadwal.
6. Kurikulum melakukan revisi secara manual.
7. Jadwal dipublikasikan.

---

## Pain Points

- Sulit mengetahui potensi bentrok sebelum sinkronisasi.
- Penyelesaian konflik masih dilakukan secara manual.
- Membutuhkan waktu yang lama.
- Risiko human error cukup tinggi.
- Perubahan satu jadwal dapat menyebabkan konflik baru.

---

# 3. Proposed Solution

## Alur Sistem Baru

```text
Master Data
      │
      ▼
Penyusunan Jadwal Jurusan
      │
      ▼
Plotting Guru
      │
      ▼
AI Conflict Predictor
      │
      ▼
Sinkronisasi Jadwal
      │
      ▼
AI Resolve Conflict
      │
      ▼
Publikasi Jadwal
```

Dengan adanya AI, sistem tidak hanya mendeteksi konflik, tetapi juga memberikan beberapa rekomendasi penyelesaian beserta alasan mengapa solusi tersebut dipilih.

---

# 4. User Roles

## Super Admin

### Hak Akses

- Mengelola seluruh data master
- Mengelola pengguna
- Mengelola hak akses
- Mengelola konfigurasi sistem

---

## Admin Jurusan

### Hak Akses

- Mengelola jadwal jurusan
- Mengelola kelas jurusan
- Melihat hasil sinkronisasi

---

## Kurikulum

### Hak Akses

- Plotting guru
- Sinkronisasi jadwal
- Menggunakan fitur AI
- Mempublikasikan jadwal

---

## Guru

### Hak Akses

- Melihat jadwal mengajar
- Mengatur preferensi mengajar
- Melihat perubahan jadwal

---

## Siswa

### Hak Akses

- Melihat jadwal pelajaran

---

# 5. Functional Requirements

## Authentication

- Login
- Logout
- Role Based Access Control

---

## Master Data

- Data Guru
- Data Mata Pelajaran
- Data Jurusan
- Data Kelas
- Data Semester
- Data Tahun Ajaran
- Data Hari
- Data Jam Pelajaran
- Data Ruangan

---

## Manajemen Jadwal

- Membuat Draft Jadwal
- Mengubah Jadwal
- Menghapus Jadwal
- Plotting Guru
- Sinkronisasi Jadwal
- Publikasi Jadwal

---

## Manajemen Konflik

- Deteksi Konflik
- Riwayat Konflik
- Riwayat Sinkronisasi
- Resolve Konflik

---

# 6. AI Features

## AI Conflict Predictor

### Tujuan

Mendeteksi potensi konflik sebelum proses sinkronisasi selesai.

### Output

- Daftar potensi bentrok
- Tingkat risiko konflik
- Guru yang berpotensi bentrok
- Ruangan yang berpotensi bentrok

---

## AI Resolve Conflict

### Tujuan

Memberikan beberapa alternatif penyelesaian konflik.

### Output

- Solusi A
- Solusi B
- Solusi C

Setiap solusi akan memiliki tingkat rekomendasi (confidence score) sehingga pengguna dapat memilih solusi yang paling sesuai.

---

## AI Explain

### Tujuan

Menjelaskan alasan AI memilih suatu solusi.

### Contoh Penjelasan

- Guru tersedia pada jam tersebut.
- Tidak menimbulkan konflik baru.
- Jumlah jam mengajar tetap sesuai.
- Ruangan tersedia.
- Tidak memengaruhi jadwal kelas lain.

---

## AI Schedule Query

### Tujuan

Memungkinkan pengguna mencari informasi jadwal menggunakan bahasa alami.

### Contoh

- Guru siapa yang bentrok hari Senin?
- Guru mana yang paling banyak mengajar minggu ini?
- Cari slot kosong Pak Ahmad.
- Mengapa jadwal XI RPL belum dapat dipublikasikan?
- Tampilkan seluruh konflik minggu ini.

---

# 7. Data Requirements

Sistem memerlukan data berikut:

- Guru
- Mata Pelajaran
- Jurusan
- Kelas
- Semester
- Tahun Ajaran
- Hari
- Jam Pelajaran
- Ruangan
- Preferensi Guru
- Jadwal
- Plotting Guru

---

# 8. Business Rules

Beberapa aturan utama dalam sistem:

- Guru tidak boleh mengajar lebih dari satu kelas pada waktu yang sama.
- Guru memiliki batas maksimal jam mengajar setiap hari.
- Guru dapat memiliki hari yang ditetapkan sebagai hari piket atau hari tidak mengajar.
- Mata pelajaran harus memenuhi jumlah jam pelajaran sesuai kurikulum.
- Kelas tidak boleh memiliki dua mata pelajaran pada waktu yang sama.
- Ruangan tidak boleh digunakan oleh lebih dari satu kelas pada waktu yang sama.
- Jadwal hanya dapat dipublikasikan apabila tidak memiliki konflik.

---

# 9. Non-Functional Requirements

## Performance

- Deteksi konflik maksimal 5 detik.
- AI Resolve maksimal 15 detik.

---

## Security

- Role Based Access Control
- Audit Log seluruh perubahan jadwal
- Autentikasi pengguna

---

## Availability

- Sistem dapat diakses selama jam operasional sekolah.
- Mendukung penggunaan oleh beberapa admin secara bersamaan.

---

# 10. Future Development

Fitur yang dapat dikembangkan pada versi berikutnya:

- AI Workload Analyzer
- AI Schedule Quality Score
- Integrasi Kalender Guru
- Notifikasi perubahan jadwal
- Mobile Application
- Integrasi dengan Sistem Akademik Sekolah
- Dashboard Analitik Akademik

---

# Lampiran (Opsional)

- Entity Relationship Diagram (ERD)
- Flowchart Sistem
- Wireframe UI/UX
- Database Schema
- API Documentation
- Tech Stack
- Timeline Pengembangan
