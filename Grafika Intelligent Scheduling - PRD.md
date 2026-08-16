# Product Requirements Document (PRD)

## Nama Project
**Grafika Intelligent Scheduling (GIS)**

## Versi
1.1

## Tanggal
13 Juli 2026

## Kategori
Jagoan Hosting Innovation Competition (JHIC) 2026 — Web Development

---

# 1. Overview

## Deskripsi

Grafika Intelligent Scheduling (GIS) merupakan platform manajemen jadwal sekolah berbasis web yang dirancang untuk membantu proses penyusunan, sinkronisasi, dan publikasi jadwal pelajaran di sekolah, khususnya SMK.

Sistem ini berfokus pada penyelesaian salah satu permasalahan utama dalam penyusunan jadwal, yaitu bentrok jadwal guru yang sering terjadi saat proses sinkronisasi antar jurusan. Dengan memanfaatkan Artificial Intelligence (AI) sebagai Decision Support System (DSS), sistem mampu mendeteksi potensi konflik, memberikan rekomendasi penyelesaian, serta membantu pengambil keputusan dengan lebih cepat dan akurat.

## Target Pengguna

Sekolah menengah kejuruan (SMK), dengan pilot project di SMKN 4 Malang (Grafika).

## Ruang Lingkup

- **MVP (v1.0):** Manajemen jadwal, plotting guru, deteksi & resolusi konflik berbasis AI, publikasi jadwal.
- **Post-MVP:** Mobile app, integrasi kalender, dashboard analitik.

---

# 2. Existing Workflow

## Alur Saat Ini

```text
1. Admin Jurusan membuat draft jadwal (tanpa guru)
2. Semua jurusan selesai membuat draft
3. Kurikulum melakukan plotting guru ke mata pelajaran
4. Kurikulum melakukan sinkronisasi seluruh jurusan
5. Ditemukan bentrok jadwal
6. Kurikulum melakukan revisi secara manual
7. Ulangi langkah 4-6 sampai tidak ada konflik
8. Jadwal dipublikasikan
```

## Pain Points

| No | Masalah | Dampak |
|----|---------|--------|
| 1 | Tidak ada cara untuk mendeteksi potensi bentrok sebelum sinkronisasi | Konflik baru ditemukan terlambat |
| 2 | Penyelesaian konflik dilakukan secara manual | Membutuhkan waktu berhari-hari |
| 3 | Perubahan satu jadwal dapat menyebabkan konflik baru | Proses revisi berulang |
| 4 | Risiko human error cukup tinggi | Jadwal yang dipublikasikan masih memiliki konflik |
| 5 | Tidak ada histori perubahan jadwal | Sulit melacak perubahan |

---

# 3. Proposed Solution

## Alur Sistem Baru

```text
Master Data
      │
      ▼
Penyusunan Jadwal Jurusan (Admin Jurusan)
      │
      ▼
Plotting Guru (Koordinator Mapel)
      │
      ▼
AI Conflict Predictor (Real-time)
      │
      ▼
Sinkronisasi Jadwal (Sistem)
      │
      ▼
AI Resolve Conflict (Koordinator Mapel + AI)
      │
      ▼
Publikasi Jadwal (Admin Jurusan)
```

## Posisi AI dalam Sistem

AI bukan chatbot utama. AI merupakan **Decision Support System (DSS)** yang membantu pengambil keputusan dalam proses sinkronisasi jadwal.

```text
┌─────────────────────────────────────────────┐
│              AI CONFLICT DETECTION           │
│  - Rule-based: Deteksi pasti (hard constraint)│
│  - ML-based: Prediksi potensi konflik        │
└─────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│              AI RESOLUTION ENGINE            │
│  - Constraint Satisfaction Problem (CSP)     │
│  - LLM: Penjelasan & Natural Language Query  │
└─────────────────────────────────────────────┘
```

## Pendekatan Hybrid AI

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Deteksi Konflik | Rule-based engine | Harus 100% akurat, tidak boleh false negative |
| Resolusi Konflik | Constraint Satisfaction + Heuristic | Solusi optimal dalam waktu terbatas |
| Penjelasan (Explain) | LLM (GPT/Gemini) | Menghasilkan penjelasan yang mudah dipahami |
| Natural Language Query | LLM dengan function calling | Mengubah bahasa alami ke query struktural |

---

# 4. User Roles

## Role Hierarchy

```text
Super Admin
    │
    ├── Admin Jurusan (scope: jurusan tertentu)
    │
    ├── Koordinator Mapel (scope: mata pelajaran tertentu)
    │       │
    │       │── Auto-create saat mata pelajaran ditambahkan
    │       │── Scope: plotting guru & resolve conflict untuk mapelnya saja
    │
    ├── Guru (scope: jadwal sendiri)
    │
    └── Siswa (scope: jadwal kelas)
```

## 4.1 Super Admin

### Hak Akses

- Mengelola seluruh data master (guru, mata pelajaran, jurusan, kelas, ruangan, semester, tahun ajaran, hari, jam pelajaran)
- Mengelola pengguna (buat, edit, nonaktifkan akun)
- Mengelola hak akses (assign role)
- Mengelola konfigurasi sistem (batas jam mengajar, jam per JP, dll)
- Melihat seluruh audit log
- Melihat dashboard statistik seluruh sekolah

### Batasan

- Tidak dapat mengubah jadwal secara langsung
- Tidak dapat melakukan plotting guru

---

## 4.2 Admin Jurusan

### Hak Akses

- Membuat draft jadwal untuk jurusan yang dikelola
- Mengubah draft jadwal
- Menghapus draft jadwal
- Melihat jadwal jurusan
- Melihat hasil sinkronisasi untuk jurusannya
- Mempublikasikan jadwal jurusan (setelah validasi)
- Melihat konflik yang melibatkan jadwal jurusannya

### Batasan

- Hanya dapat mengelola jadwal untuk jurusan tertentu
- Tidak dapat melakukan plotting guru
- Tidak dapat mengubah jadwal yang sudah dipublikasikan

---

## 4.3 Koordinator Mapel

### Hak Akses

- Melakukan plotting guru untuk mata pelajaran yang dikoordinasi
- Melihat jadwal untuk mata pelajaran yang dikoordinasi
- Menggunakan fitur AI Conflict Predictor
- Menggunakan fitur AI Resolve Conflict
- Melihat dan menyelesaikan konflik yang melibatkan mata pelajaran yang dikoordinasi
- Melihat preferensi guru pada mata pelajaran yang dikoordinasi
- Melihat riwayat sinkronisasi untuk mata pelajaran yang dikoordinasi

### Batasan

- Hanya dapat plotting guru untuk mata pelajaran tertentu
- Tidak dapat mengubah jadwal jurusan
- Tidak dapat mempublikasikan jadwal
- Tidak dapat mengelola data master
- Tidak dapat melihat jadwal mata pelajaran lain

### Auto-Creation Rule

```text
Ketika Super Admin menambahkan mata pelajaran baru:
1. Sistem otomatis membuat akun Koordinator Mapel
2. Username: mapel_[kode_mapel] (contoh: mapel_pbk)
3. Password default: [didefinisikan di konfigurasi]
4. Super Admin dapat mengganti akun koordinator kapan saja
5. Jika mata pelajaran dihapus, akun koordinator dinonaktifkan
```

---

## 4.4 Guru

### Hak Akses

- Melihat jadwal mengajar sendiri
- Mengatur preferensi mengajar (hari/tidak mengajar, slot waktu, prioritas mapel)
- **Request jam/jadwal tertentu tidak bisa mengajar** (dengan alasan)
- Melihat status request yang diajukan
- Melihat perubahan jadwal
- Melihat informasi ruangan

### Batasan

- Tidak dapat mengubah jadwal
- Tidak dapat melihat jadwal guru lain
- Request harus disetujui oleh Koordinator Mapel terkait

---

## 4.5 Siswa

### Hak Akses

- Melihat jadwal pelajaran kelas sendiri
- Melihat informasi guru pengajar
- Melihat informasi ruangan

### Batasan

- Tidak dapat mengubah apa pun
- Hanya melihat jadwal kelas sendiri

---

# 5. Functional Requirements

## 5.1 Authentication

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| AUTH-01 | Login | Pengguna login dengan username dan password | - Redirect ke dashboard sesuai role<br>- Sesi berakhir setelah 30 menit tidak aktif |
| AUTH-02 | Logout | Pengguna logout dari sistem | - Sesi dihapus<br>- Redirect ke halaman login |
| AUTH-03 | Role Based Access Control | Akses diatur berdasarkan role | - Menu dan fitur ditampilkan sesuai role<br>- API mengembalikan 403 jika akses tidak diizinkan |
| AUTH-04 | Reset Password | Super Admin dapat reset password pengguna | - Password baru dikirim via email/notifikasi<br>- Pengguna diwajibkan mengubah password setelah login pertama |

---

## 5.2 Master Data Management

### 5.2.1 Data Guru

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-01 | Tambah Guru | Super Admin menambah data guru | - Wajib: NIP, nama, mata pelajaran<br>- NIP harus unik<br>- Email harus valid dan unik |
| MDS-02 | Edit Guru | Super Admin mengubah data guru | - Perubahan tercatat di audit log |
| MDS-03 | Hapus/Nonaktifkan Guru | Super Admin menonaktifkan guru | - Guru yang aktif di jadwal tidak dapat dihapus<br>- Guru dinonaktifkan, bukan dihapus hard |
| MDS-04 | Import Guru | Super Admin import dari Excel | - Template tersedia<br>- Validasi data sebelum import<br>- Tampilkan summary hasil import |
| MDS-05 | Cari & Filter Guru | Mencari guru berdasarkan NIP/nama/mapel | - Pencarian fuzzy<br>- Filter by mata pelajaran, status |

### 5.2.2 Data Mata Pelajaran

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-10 | Tambah Mata Pelajaran | Super Admin menambah mata pelajaran | - Wajib: kode, nama, jumlah JP per minggu<br>- Otomatis membuat akun Koordinator Mapel |
| MDS-11 | Edit Mata Pelajaran | Super Admin mengubah data mata pelajaran | - Perubahan jumlah JP mempengaruhi jadwal yang sudah ada |
| MDS-12 | Hapus Mata Pelajaran | Super Admin menghapus mata pelajaran | - Tidak dapat dihapus jika masih ada jadwal aktif<br>- Akun koordinator dinonaktifkan |

### 5.2.3 Data Jurusan

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-20 | Tambah Jurusan | Super Admin menambah jurusan | - Wajib: kode, nama<br>- Otomatis membuat akun Admin Jurusan |
| MDS-21 | Edit Jurusan | Super Admin mengubah data jurusan | - |
| MDS-22 | Hapus Jurusan | Super Admin menghapus jurusan | - Tidak dapat dihapus jika masih ada kelas aktif |

### 5.2.4 Data Kelas

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-30 | Tambah Kelas | Super Admin menambah kelas | - Wajib: nama kelas, jurusan, tahun ajaran<br>- Format: [Jurusan] [Tingkat] [Nomor] (contoh: XI RPL 1) |
| MDS-31 | Edit Kelas | Super Admin mengubah data kelas | - |
| MDS-32 | Hapus Kelas | Super Admin menghapus kelas | - Tidak dapat dihapus jika masih ada jadwal aktif |

### 5.2.5 Data Semester & Tahun Ajaran

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-40 | Kelola Semester | Super Admin menambah/mengubah semester | - Format: [Tahun Ajaran] [Ganjil/Genap] (contoh: 2026/2027 Ganjil) |
| MDS-41 | Kelola Tahun Ajaran | Super Admin menambah tahun ajaran | - Format: YYYY/YYYY (contoh: 2026/2027) |

### 5.2.6 Data Hari & Jam Pelajaran

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-50 | Kelola Hari | Super Admin mengatur hari aktif | - Default: Senin-Jumat<br>- Bisa menambah hari Sabtu (untuk SMK) |
| MDS-51 | Kelola Jam Pelajaran | Super Admin mengatur slot jam | - Default: 7 slot per hari<br>- Konfigurasi menit per JP (35/45/60 menit) |
| MDS-52 | Jam Istirahat | Super Admin mengatur jam istirahat | - Ditandai sebagai slot non-aktif<br>- Tidak bisa dijadwalkan |

### 5.2.7 Data Ruangan

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| MDS-60 | Tambah Ruangan | Super Admin menambah ruangan | - Wajib: nama, tipe (kelas/lab/bengkel)<br>- Kapasitas (opsional) |
| MDS-61 | Edit Ruangan | Super Admin mengubah data ruangan | - |
| MDS-62 | Hapus Ruangan | Super Admin menghapus ruangan | - Tidak dapat dihapus jika masih terpakai di jadwal |

---

## 5.3 Request Jam Tidak Mengajar (Guru)

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| REQ-01 | Buat Request | Guru membuat request jam/jadwal tertentu tidak bisa mengajar | - Pilih hari dan slot waktu<br>- Wajib: alasan request<br>- Wajib: durasi (sekali / berulang)<br>- Status: Menunggu Persetujuan |
| REQ-02 | Lihat Daftar Request | Guru melihat daftar request yang diajukan | - Filter by status (Menunggu/Diterima/Ditolak)<riwayat request sebelumnya |
| REQ-03 | Batalkan Request | Guru membatalkan request yang belum disetujui | - Hanya bisa dibatalkan jika status "Menunggu" |
| REQ-04 | Setujui Request | Koordinator Mapel menyetujui request guru | - Konfirmasi sebelum approve<br>- Jika disetujui, slot waktu guru otomatis ditandai tidak tersedia<br>- Notifikasi ke guru |
| REQ-05 | Tolak Request | Koordinator Mapel menolak request guru | - Wajib: alasan penolakan<br>- Notifikasi ke guru |
| REQ-06 | Cek Ketersediaan | Koordinator Mapel melihat slot waktu yang tersedia untuk guru | - Highlight slot yang sudah ada request<br>- Tampilkan jumlah request per slot |

### Alur Request

```text
1. Guru membuat request
   ├── Pilih hari
   ├── Pilih slot waktu (JP)
   ├── Isi alasan
   └── Submit
         │
         ▼
2. Status: Menunggu Persetujuan
   │
   ├── Koordinator Mapel melihat request
   │     ├── Setujui → Status: Diterima → Slot tidak tersedia untuk guru
   │     └── Tolak → Status: Ditolak → Guru dapat buat request baru
   │
   └── Guru dapat membatalkan request (jika masih Menunggu)
```

### Validasi Request

| Kondisi | Hasil |
|---------|-------|
| Guru sudah ada jadwal di slot tersebut | Request ditolak otomatis |
| Guru sudah request di slot yang sama (status Menunggu) | Request duplikat, ditolak |
| Slot waktu sudah penuh (semua guru ada jadwal) | Request ditolak, saran slot lain |
| Guru melebihi batas request per minggu | Peringatan, tetapi masih bisa submit |

---

## 5.4 Schedule Management

### 5.3.1 Draft Jadwal

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| SCD-01 | Buat Draft Jadwal | Admin Jurusan membuat jadwal kosong per kelas | - Pilih kelas, semester<br>- Otomatis generate slot kosong berdasarkan hari dan jam pelajaran |
| SCD-02 | Isi Mata Pelajaran | Admin Jurusan mengisi mata pelajaran ke slot | - Validasi: jumlah JP harus sesuai kurikulum<br>- Validasi: tidak ada 2 mapel di slot yang sama |
| SCD-03 | Edit Jadwal | Admin Jurusan mengubah jadwal | - Perubahan tercatat di audit log<br>- Jika sudah ada plotting, koordinator mapel diberitahu |
| SCD-04 | Hapus Jadwal | Admin Jurusan menghapus jadwal dari slot | - Tidak dapat menghapus jika sudah ada guru diplotting |
| SCD-05 | Lihat Status | Admin Jurusan melihat status jadwal jurusannya | - Status: Draft, Terplotting, Sinkron, Konflik, Valid, Dipublikasikan |
| SCD-06 | Auto-Save | Sistem auto-save perubahan | - Interval: 30 detik<br>- Tampilkan indikator "Tersimpan" / "Menyimpan..." |

### 5.3.2 Plotting Guru

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| SCD-10 | Plot Guru ke Mapel | Koordinator Mapel menugaskan guru ke mata pelajaran | - Pilih guru yang mengampu mapel tersebut<br>- Validasi: guru tidak bentrok di slot yang sama<br>- Validasi: guru tidak melebihi batas jam/hari |
| SCD-11 | Re-Plot Guru | Koordinator Mapel mengganti guru yang sudah diplotting | - Perubahan tercatat di audit log<br>- AI Conflict Predictor otomatis dijalankan |
| SCD-12 | Batch Plotting | Koordinator Mapel melakukan plotting untuk beberapa kelas sekaligus | - Pilih beberapa kelas, sistem suggest guru terbaik<br>- Konfirmasi sebelum apply |
| SCD-13 | Lihat Beban Guru | Koordinator Mapel melihat total jam mengajar guru | - Tampilkan per hari dan per minggu<br>- Highlight jika mendekati/melebihi batas |
| SCD-14 | Lihat Preferensi Guru | Koordinator Mapel melihat preferensi guru | - Hari/tidak mengajar<br>- Slot waktu yang dihindari<br>- Prioritas mapel |

### 5.3.3 Sinkronisasi Jadwal

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| SCD-20 | Jalankan Sinkronisasi | Sistem melakukan sinkronisasi seluruh jadwal | - Deteksi semua konflik<br>- Tampilkan daftar konflik<br>- Waktu proses < 5 detik |
| SCD-21 | Lihat Hasil Sinkronisasi | Pengguna melihat hasil sinkronisasi | - Jumlah konflik per kategori<br>- Detail setiap konflik<br>- Riwayat sinkronisasi sebelumnya |
| SCD-22 | Riwayat Sinkronisasi | Sistem mencatat seluruh proses sinkronisasi | - Timestamp<br>- Siapa yang menjalankan<br>- Jumlah konflik ditemukan<br>- Jumlah konflik diselesaikan |

### 5.3.4 Publikasi Jadwal

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| SCD-30 | Publish Jadwal | Admin Jurusan mempublikasikan jadwal | - Hanya bisa publish jika tidak ada konflik<br>- Konfirmasi sebelum publish<br>- Notifikasi ke koordinator mapel dan guru terdampak |
| SCD-31 | Unpublish Jadwal | Admin Jurusan membatalkan publikasi | - Hanya bisa unpublish jika belum ada perubahan dari guru<br>- Audit log tercatat |
| SCD-32 | Lihat Jadwal Dipublikasikan | Guru dan siswa melihat jadwal | - Filter by kelas, guru, hari<br>- Tampilan kalender dan tabel |

---

## 5.4 Conflict Management

### 5.4.1 Deteksi Konflik

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| CNF-01 | Real-time Detection | Sistem mendeteksi konflik secara real-time saat plotting | - Muncul peringatan instan saat konflik terdeteksi<br>- Tidak perlu tunggu sinkronisasi manual |
| CNF-02 | Batch Detection | Deteksi konflik seluruh jadwal sekaligus | - Dijalankan saat sinkronisasi<br>- Waktu proses < 5 detik untuk 1000+ jadwal |
| CNF-03 | Kategori Konflik | Sistem mengkategorikan konflik | - Guru bentrok (mengajar 2 kelas bersamaan)<br>- Guru overload (melebihi batas jam/hari)<br>- Guru di hari tidak mengajar/piket<br>- **Guru dijam yang sudah di-request tidak mengajar**<br>- Ruangan bentrok (2 kelas di ruangan sama)<br>- Jam tidak terpenuhi (kurang dari target kurikulum) |

### 5.4.2 Tampilan Konflik

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| CNF-10 | Daftar Konflik | Menampilkan seluruh konflik | - Filter by kategori, guru, kelas, status<br>- Sort by severity (tinggi ke rendah)<br>- Pagination |
| CNF-11 | Detail Konflik | Menampilkan detail satu konflik | - Kategori konflik<br>- Guru yang terlibat<br>- Kelas yang terlibat<br>- Slot waktu yang bentrok<br>- Ruangan yang terlibat<br>- Severity level |
| CNF-12 | Severity Level | Penentuan tingkat keparahan konflik | - High: Guru bentrok di 2+ kelas<br>- Medium: Guru melebihi batas jam<br>- Low: Ruangan hampir penuh |

### 5.4.3 Resolusi Konflik

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| CNF-20 | Manual Resolve | Koordinator Mapel menyelesaikan konflik secara manual | - Ubah slot waktu<br>- Ubah guru<br>- Ubah ruangan<br>- Perubahan tercatat di audit log |
| CNF-21 | AI Resolve | AI memberikan rekomendasi solusi | - Minimal 3 alternatif solusi<br>- Confidence score per solusi<br>- Waktu proses < 15 detik |
| CNF-22 | Terapkan Solusi | Koordinator Mapel memilih dan menerapkan solusi AI | - Konfirmasi sebelum apply<br>- Perubahan tercatat di audit log<br>- Konflik baru (jika ada) langsung terdeteksi |
| CNF-23 | Riwayat Resolusi | Sistem mencatat seluruh proses resolusi | - Siapa yang menyelesaikan<br>- Kapan diselesaikan<br>- Solusi apa yang dipilih<br>- Alasan (dari AI Explain) |

---

## 5.5 Audit Log

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| AUD-01 | Catatan Perubahan | Sistem mencatat setiap perubahan | - Siapa (user ID)<br>- Kapan (timestamp)<br>- Apa yang diubah (field)<br>- Sebelum dan sesudah (before/after) |
| AUD-02 | Filter Audit Log | Super Admin memfilter audit log | - By user, tanggal, jenis perubahan, entitas |
| AUD-03 | Ekspor Audit Log | Super Admin mengekspor audit log | - Format CSV/Excel<br- Filter by rentang tanggal |

---

## 5.6 Notification

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| NTF-01 | Notifikasi Plotting | Koordinator Mapel diberitahu saat jadwal mapelnya diubah | - In-app notification<br>- Email (opsional) |
| NTF-02 | Notifikasi Konflik | Pengguna terdampak diberitahu saat konflik terdeteksi | - Tampilkan di dashboard<br>- Detail konflik |
| NTF-03 | Notifikasi Publikasi | Guru dan siswa diberitahu saat jadwal dipublikasikan | - In-app notification<br>- Email |
| NTF-04 | Notifikasi Perubahan | Guru diberitahu saat jadwal mengajarnya berubah | - In-app notification<br>- Detail perubahan |
| **NTF-05** | **Notifikasi Request Diterima** | **Guru diberitahu saat request jam tidak mengajar disetujui** | **- In-app notification<br>- Detail slot yang disetujui** |
| **NTF-06** | **Notifikasi Request Ditolak** | **Guru diberitahu saat request jam tidak mengajar ditolak** | **- In-app notification<br>- Alasan penolakan** |

---

## 5.7 Export/Import

| ID | Fitur | Deskripsi | Acceptance Criteria |
|----|-------|-----------|---------------------|
| EXP-01 | Export Excel | Export jadwal ke Excel | - Filter by kelas, guru, jurusan<br>- Format tabel rapi<br>- Include header dan metadata |
| EXP-02 | Export PDF | Export jadwal ke PDF | - Format siap cetak<br>- Include logo sekolah<br>- Format A4 |
| EXP-03 | Import Excel | Import jadwal dari Excel | - Template tersedia<br>- Validasi data sebelum import<br>- Tampilkan summary hasil import |

---

# 6. AI Features

## 6.1 AI Conflict Predictor

### Tujuan

Mendeteksi potensi konflik secara real-time bahkan sebelum proses sinkronisasi selesai.

### Trigger

- Saat Koordinator Mapel melakukan plotting/re-plotting
- Saat Admin Jurusan mengubah jadwal
- Saat sinkronisasi manual dijalankan

### Output

| Field | Deskripsi |
|-------|-----------|
| Conflict ID | ID unik konflik |
| Kategori | Guru bentrok / Guru overload / Guru hari tidak aktif / Ruangan bentrok / Jam tidak terpenuhi |
| Severity | High / Medium / Low |
| Guru Terlibat | Daftar guru yang bermasalah |
| Kelas Terlibat | Daftar kelas yang terdampak |
| Slot Waktu | Hari dan jam pelajaran yang bentrok |
| Ruangan | Ruangan yang terlibat (jika ada) |
| Timestamp | Kapan konflik terdeteksi |

### Acceptance Criteria

- [ ] Deteksi konflik terjadi dalam < 1 detik setelah perubahan jadwal
- [ ] Tidak ada false negative (konflik yang lolos)
- [ ] False positive < 5% (konflik palsu)
- [ ] Konflik ditampilkan dengan warna sesuai severity

---

## 6.2 AI Resolve Conflict

### Tujuan

Memberikan beberapa alternatif penyelesaian konflik beserta confidence score.

### Trigger

- Saat pengguna meminta resolusi AI untuk konflik tertentu
- Saat sinkronisasi menemukan konflik

### Input

- Detail konflik (kategori, guru, kelas, slot waktu)
- Data terkait (jadwal guru lain, preferensi guru, ruangan tersedia)

### Output

```text
Konflik: Guru Ahmad bentrok di XI RPL 1 (Senin, JP 3-4) dan XII TKJ 2 (Senin, JP 3-4)

Solusi A: Pindahkan Guru Ahmad di XII TKJ 2 ke slot Senin JP 5-6
Confidence: 97%
Alasan:
  ✓ Guru Ahmad tersedia di slot Senin JP 5-6
  ✓ Tidak menimbulkan konflik baru
  ✓ Jumlah jam mengajar tetap sesuai
  ✓ Ruangan XII TKJ 2 tersedia di slot tersebut

Solusi B: Ganti Guru Ahmad di XII TKJ 2 dengan Guru Budi
Confidence: 91%
Alasan:
  ✓ Guru Budi tersedia di slot tersebut
  ✓ Guru Budi memiliki kompetensi yang sesuai
  ⚠ Guru Budi sudah mengajar 4 jam di hari yang sama (mendekati batas)

Solusi C: Geser seluruh jadwal XII TKJ 2 satu slot ke bawah
Confidence: 83%
Alasan:
  ✓ Tidak ada konflik baru
  ⚠ Memengaruhi 3 jam pelajaran lain
  ⚠ Perlu konfirmasi dari Admin Jurusan TKJ
```

### Acceptance Criteria

- [ ] Minimal 3 alternatif solusi dihasilkan
- [ ] Confidence score antara 0-100%
- [ ] Setiap solusi memiliki minimal 3 alasan
- [ ] Waktu proses < 15 detik
- [ ] Solusi tidak menimbulkan konflik baru

---

## 6.3 AI Explain

### Tujuan

Menjelaskan alasan AI memilih suatu solusi secara transparan.

### Jenis Penjelasan

| Kategori | Contoh Penjelasan |
|----------|-------------------|
| Ketersediaan Guru | "Guru Ahmad tersedia di slot tersebut karena tidak ada jadwal lain" |
| Beban Kerja | "Guru Ahmad sudah mengajar 16 jam minggu ini, masih di bawah batas 24 jam" |
| Preferensi | "Guru Ahmad tidak memiliki preferensi hari/tidak mengajar di hari tersebut" |
| Konflik Baru | "Solusi ini tidak menimbulkan konflik baru di kelas atau guru lain" |
| Ruangan | "Ruangan Lab RPL tersedia di slot tersebut" |
| Dampak | "Solusi ini tidak memengaruhi jadwal kelas lain" |

### Acceptance Criteria

- [ ] Penjelasan menggunakan bahasa Indonesia yang mudah dipahami
- [ ] Setiap solusi memiliki minimal 3 alasan
- [ ] Alasan dapat diverifikasi oleh pengguna
- [ ] Penjelasan spesifik (menyebut nama guru, kelas, slot waktu)

---

## 6.4 AI Schedule Query

### Tujuan

Memungkinkan pengguna mencari informasi jadwal menggunakan bahasa alami.

### Contoh Query

| Query | Jawaban yang Diharapkan |
|-------|-------------------------|
| "Guru siapa yang bentrok hari Senin?" | Daftar guru yang memiliki konflik di hari Senin beserta detailnya |
| "Guru mana yang paling banyak mengajar minggu ini?" | Ranking guru berdasarkan total jam mengajar |
| "Cari slot kosong Pak Ahmad" | Daftar slot waktu di mana Guru Ahmad tidak ada jadwal |
| "Mengapa jadwal XI RPL belum dipublikasikan?" | Penjelasan konflik yang menghalangi publikasi |
| "Tampilkan konflik minggu ini" | Daftar konflik dalam rentang minggu berjalan |

### Acceptance Criteria

- [ ] Query diproses dalam < 5 detik
- [ ] Jawaban akurat berdasarkan data aktual
- [ ] Jika query ambigu, sistem meminta klarifikasi
- [ ] Mendukung query dalam Bahasa Indonesia

---

# 7. Data Requirements

## 7.1 Entitas Utama

| Entitas | Deskripsi | Relasi |
|---------|-----------|--------|
| Guru | Data guru pengajar | → Mata Pelajaran (many-to-many) |
| Mata Pelajaran | Data mata pelajaran | → Jurusan (many-to-many), → Guru (many-to-many) |
| Jurusan | Data jurusan/program keahlian | → Kelas (one-to-many) |
| Kelas | Data kelas | → Jurusan (many-to-one), → Jadwal (one-to-many) |
| Semester | Data semester | → Jadwal (one-to-many) |
| Tahun Ajaran | Data tahun ajaran | → Semester (one-to-many) |
| Hari | Hari aktif sekolah | → Jadwal (one-to-many) |
| Jam Pelajaran | Slot waktu | → Jadwal (one-to-many) |
| Ruangan | Data ruangan | → Jadwal (one-to-many) |
| Preferensi Guru | Preferensi waktu mengajar guru | → Guru (many-to-one) |
| **Request Jam Tidak Mengajar** | **Request guru untuk jam/jadwal tertentu tidak bisa mengajar** | **→ Guru (many-to-one), → Hari (many-to-one), → Jam Pelajaran (many-to-one)** |
| Jadwal | Jadwal pelajaran | → Kelas, Guru, Mata Pelajaran, Ruangan, Hari, Jam Pelajaran |
| Plotting | Penugasan guru ke mata pelajaran | → Guru, Mata Pelajaran, Jadwal |
| Konflik | Data konflik jadwal | → Jadwal (many-to-many) |
| Resolusi | Data penyelesaian konflik | → Konflik (many-to-one) |
| Audit Log | Log seluruh perubahan | → User (many-to-one) |
| User | Akun pengguna | → Role (many-to-one) |
| Role | Role pengguna | → User (one-to-many) |

## 7.2 Data Guru

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| id | UUID | Ya | Primary key |
| nip | VARCHAR(20) | Ya | Nomor Induk Pegawai, unik |
| nama | VARCHAR(100) | Ya | Nama lengkap |
| email | VARCHAR(100) | Ya | Email, unik |
| telepon | VARCHAR(15) | Tidak | Nomor telepon |
| status | ENUM | Ya | aktif / nonaktif |
| created_at | TIMESTAMP | Ya | Waktu pembuatan |
| updated_at | TIMESTAMP | Ya | Waktu update terakhir |

## 7.3 Data Mata Pelajaran

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| id | UUID | Ya | Primary key |
| kode | VARCHAR(10) | Ya | Kode mata pelajaran, unik |
| nama | VARCHAR(100) | Ya | Nama mata pelajaran |
| jp_per_minggu | INT | Ya | Jumlah jam pelajaran per minggu |
| tipe | ENUM | Ya | umum / khusus / produktif |
| created_at | TIMESTAMP | Ya | Waktu pembuatan |
| updated_at | TIMESTAMP | Ya | Waktu update terakhir |

## 7.4 Data Jadwal

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| id | UUID | Ya | Primary key |
| kelas_id | UUID | Ya | Foreign key → Kelas |
| mata_pelajaran_id | UUID | Ya | Foreign key → Mata Pelajaran |
| guru_id | UUID | Tidak | Foreign key → Guru (isi saat plotting) |
| ruangan_id | UUID | Tidak | Foreign key → Ruangan |
| hari_id | UUID | Ya | Foreign key → Hari |
| jam_pelajaran_id | UUID | Ya | Foreign key → Jam Pelajaran |
| semester_id | UUID | Ya | Foreign key → Semester |
| status | ENUM | Ya | draft / terplotting / sinkron / konflik / valid / dipublikasikan |
| created_at | TIMESTAMP | Ya | Waktu pembuatan |
| updated_at | TIMESTAMP | Ya | Waktu update terakhir |

## 7.5 Data Request Jam Tidak Mengajar

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| id | UUID | Ya | Primary key |
| guru_id | UUID | Ya | Foreign key → Guru |
| hari_id | UUID | Ya | Foreign key → Hari |
| jam_pelajaran_id | UUID | Ya | Foreign key → Jam Pelajaran |
| alasan | TEXT | Ya | Alasan request |
| tipe | ENUM | Ya | sekali / berulang |
| status | ENUM | Ya | menunggu / diterima / ditolak |
| disetujui_oleh | UUID | Tidak | Foreign key → User (Koordinator Mapel) |
| alasan_penolakan | TEXT | Tidak | Alasan jika ditolak |
| created_at | TIMESTAMP | Ya | Waktu pembuatan |
| updated_at | TIMESTAMP | Ya | Waktu update terakhir |

---

# 8. Business Rules

## 8.1 Hard Constraint (Harus Dipenuhi)

| ID | Aturan | Dampak Pelanggaran |
|----|--------|---------------------|
| BR-01 | Guru tidak boleh mengajar di dua kelas pada waktu yang sama | Konflik High |
| BR-02 | Guru tidak boleh mengajar di hari yang ditetapkan sebagai hari tidak mengajar/piket | Konflik High |
| BR-03 | Guru tidak boleh melebihi batas maksimal jam mengajar per hari | Konflik Medium |
| BR-04 | Kelas tidak boleh memiliki dua mata pelajaran pada waktu yang sama | Konflik High |
| BR-05 | Ruangan tidak boleh digunakan oleh lebih dari satu kelas pada waktu yang sama | Konflik Medium |
| BR-06 | Mata pelajaran harus memenuhi jumlah jam pelajaran sesuai kurikulum | Konflik Low |
| BR-07 | Jadwal hanya dapat dipublikasikan apabila tidak memiliki konflik | Blokir publikasi |
| **BR-08** | **Guru tidak boleh diplotting di jam/jadwal yang sudah di-request tidak mengajar (status: Diterima)** | **Konflik High** |

## 8.2 Soft Constraint (Harus Dipertimbangkan)

| ID | Aturan | Dampak Pelanggaran |
|----|--------|---------------------|
| BR-10 | Guru idealnya mengajar mata pelajaran yang sesuai dengan kompetensinya | Rekomendasi AI |
| BR-11 | Guru idealnya tidak mengajar terlalu banyak jam di hari yang sama | Rekomendasi AI |
| BR-12 | Ruangan yang sesuai dengan tipe mata pelajaran (lab untuk praktik) | Rekomendasi AI |
| BR-13 | Jadwal yang sudah dipublikasikan sebaiknya tidak diubah | Peringatan |

## 8.3 Auto-Creation Rules

| ID | Aturan | Trigger |
|----|--------|---------|
| BR-20 | Akun Koordinator Mapel otomatis dibuat saat mata pelajaran baru ditambahkan | Super Admin tambah mata pelajaran |
| BR-21 | Akun Admin Jurusan otomatis dibuat saat jurusan baru ditambahkan | Super Admin tambah jurusan |
| BR-22 | Status jadwal otomatis berubah menjadi "Konflik" saat konflik terdeteksi | Real-time detection |
| BR-23 | Status jadwal otomatis berubah menjadi "Valid" saat semua konflik terselesaikan | Setelah resolve conflict |

---

# 9. Non-Functional Requirements

## 9.1 Performance

| Metrik | Target | Keterangan |
|--------|--------|------------|
| Deteksi Konflik | < 5 detik | Untuk 1000+ jadwal |
| AI Resolve | < 15 detik | Untuk 1 konflik |
| Load Time | < 3 detik | Halaman utama |
| API Response | < 1 detik | Rata-rata response time |

## 9.2 Security

| Fitur | Deskripsi |
|-------|-----------|
| HTTPS | Seluruh komunikasi terenkripsi |
| JWT Token | Autentikasi berbasis token |
| RBAC | Akses diatur berdasarkan role |
| Input Validation | Validasi input di frontend dan backend |
| SQL Injection Prevention | Parameterized query |
| XSS Prevention | Sanitasi input |
| Rate Limiting | Batasi request per menit |
| Audit Log | Catatan seluruh perubahan data |

## 9.3 Availability

| Fitur | Deskripsi |
|-------|-----------|
| Uptime | 99.5% (selama jam operasional sekolah) |
| Concurrent Users | Mendukung minimal 50 pengguna simultan |
| Backup | Otomatis backup harian |
| Recovery | Dapat dipulihkan dalam 1 jam |

## 9.4 Usability

| Fitur | Deskripsi |
|-------|-----------|
| Responsive | Dapat diakses dari desktop dan tablet |
| Bahasa Indonesia | Seluruh UI menggunakan Bahasa Indonesia |
| Help | Tersedia tooltip dan panduan penggunaan |
| Keyboard Shortcut | Shortcut untuk fitur utama |

---

# 10. User Flows

## 10.1 Flow Plotting Guru (Koordinator Mapel)

```text
1. Koordinator Mapel login
2. Lihat daftar kelas yang mengambil mata pelajaran
3. Pilih kelas tertentu
4. Lihat slot waktu yang tersedia
5. Pilih guru untuk diplotting
6. Sistem validasi:
   a. Guru tidak bentrok? → Lanjut
   b. Guru tidak overload? → Lanjut
   c. Guru di hari aktif? → Lanjut
7. AI Conflict Predictor otomatis dijalankan
8. Jika konflik:
   a. Tampilkan konflik
   b. Tampilkan solusi AI
   c. Pilih solusi atau manual resolve
9. Plotting tersimpan
10. Ulangi untuk kelas berikutnya
```

## 10.2 Flow Sinkronisasi & Resolusi Konflik

```text
1. Koordinator Mapel / Admin Jurusan menjalankan sinkronisasi
2. Sistem mendeteksi seluruh konflik
3. Tampilkan daftar konflik:
   a. Guru bentrok (High)
   b. Guru overload (Medium)
   c. Ruangan bentrok (Medium)
   d. Jam tidak terpenuhi (Low)
4. Untuk setiap konflik:
   a. Klik "Resolusi AI"
   b. Sistem menghasilkan 3+ solusi
   c. Lihat penjelasan (AI Explain)
   d. Pilih solusi atau manual resolve
5. Setelah semua konflik terselesaikan:
   a. Status jadwal berubah menjadi "Valid"
   b. Admin Jurusan dapat mempublikasikan
```

## 10.3 Flow Publikasi Jadwal

```text
1. Admin Jurusan memilih jadwal yang valid
2. Klik "Publikasikan"
3. Sistem konfirmasi:
   "Apakah Anda yakin ingin mempublikasikan jadwal kelas X?
   Seluruh guru dan siswa akan melihat jadwal ini."
4. Admin Jurusan konfirmasi
5. Status jadwal berubah menjadi "Dipublikasikan"
6. Notifikasi terkirim ke:
   a. Guru yang terdampak
   b. Siswa di kelas tersebut
   c. Koordinator Mapel terkait
7. Jadwal dapat dilihat di halaman publik
```

---

# 11. Edge Cases

| No | Edge Case | Penanganan |
|----|-----------|------------|
| 1 | Guru mengajar di 2 jurusan dengan slot waktu sama | Konflik High, harus diselesaikan sebelum publish |
| 2 | Guru resign saat jadwal sudah dipublikasikan | Admin Jurusan harus re-plotting guru lain, lalu republish |
| 3 | Mata pelajaran dihapus saat jadwal sudah ada | Tidak bisa dihapus jika masih ada jadwal aktif |
| 4 | Koordinator Mapel nonaktif saat plotting belum selesai | Super Admin assign koordinator baru |
| 5 | Ada 2 koordinator mapel yang resolve konflik yang sama | Optimistic locking, yang pertama apply yang menang |
| 6 | AI menghasilkan solusi yang menimbulkan konflik baru | Sistem otomatis deteksi konflik baru setelah apply solusi |
| 7 | Siswa membuka jadwal yang belum dipublikasikan | Redirect ke halaman "Jadwal belum tersedia" |
| 8 | Jam pelajaran berbeda antar sekolah | Konfigurable per sekolah (35/45/60 menit) |
| 9 | Ada guru yang mengampu 2 mata pelajaran berbeda | Diperbolehkan, tapi harus diplotting terpisah oleh koordinator masing-masing |
| 10 | Ruangan yang sama digunakan untuk 2 kelas di slot berbeda | Diperbolehkan (tidak bentrok) |
| **11** | **Guru request jam yang sudah ada jadwal** | **Request ditolak otomatis, guru diberitahu sudah ada jadwal** |
| **12** | **Guru request jam yang sama dengan request sebelumnya (status Menunggu)** | **Request duplikat, ditolak** |
| **13** | **Semua guru request jam yang sama** | **Peringatan ke Koordinator Mapel, saran alternatif** |
| **14** | **Request disetujui setelah jadwal dipublikasikan** | **Jadwal perlu di-replotting, notifikasi ke Admin Jurusan** |

---

# 12. Improvement Recommendations

## 12.1 Berdasarkan Pengalaman Sistem ERP/Academic

| No | Rekomendasi | Alasan |
|----|-------------|--------|
| 1 | Gunakan status flow yang jelas | Memudahkan tracking progress jadwal |
| 2 | Implement optimistic locking | Mencegah konflik saat多人 edit bersamaan |
| 3 | Sediakan dashboard summary | Koordinator Mapel perlu gambaran cepat |
| 4 | Log semua perubahan | Audit trail penting untuk akuntabilitas |
| 5 | Auto-save saat editing | Mencegah kehilangan data |
| 6 | Sediakan undo/redo | Memudahkan koreksi kesalahan |
| 7 | Gunakan soft delete | Data tidak hilang permanen |
| 8 | Sediakan filter & search yang kuat | Memudahkan pencarian data |
| 9 | Implement pagination | Performa tetap baik dengan data banyak |
| 10 | Sediakan export untuk semua data | Memudahkan reporting |

## 12.2 Arsitektur AI

| No | Rekomendasi | Alasan |
|----|-------------|--------|
| 1 | Rule-based untuk deteksi konflik | Harus 100% akurat, tidak boleh false negative |
| 2 | CSP untuk resolusi konflik | Solusi optimal dalam waktu terbatas |
| 3 | LLM untuk penjelasan & query | Menghasilkan output yang mudah dipahami |
| 4 | Cache hasil deteksi konflik | Mengurangi waktu pemrosesan |
| 5 | Batch processing untuk sinkronisasi | Efisien untuk data dalam jumlah besar |

---

# 13. Future Development

| Fitur | Deskripsi | Prioritas |
|-------|-----------|-----------|
| AI Workload Analyzer | Analisis beban kerja guru dan rekomendasi distribusi | Tinggi |
| AI Schedule Quality Score | Penilaian kualitas jadwal secara otomatis | Tinggi |
| Mobile Application | Akses jadwal dari mobile | Sedang |
| Integrasi Kalender | Sinkronisasi dengan Google Calendar | Sedang |
| Notifikasi WhatsApp/Telegram | Kirim notifikasi via messaging | Sedang |
| Dashboard Analitik | Visualisasi data jadwal dan konflik | Rendah |
| Integrasi Dapodik | Sinkronisasi data dari Dapodik | Rendah |
| Multi-School Support | Mendukung beberapa sekolah dalam satu instance | Rendah |

---

# 14. Assumptions & Dependencies

## 14.1 Assumptions

| No | Asumsi | Dampak |
|----|--------|--------|
| 1 | Setiap mata pelajaran memiliki minimal 1 guru | Jika tidak, plotting tidak dapat dilakukan |
| 2 | Jam pelajaran per hari maksimal 7-8 slot | Performa deteksi konflik |
| 3 | Jumlah guru per mata pelajaran maksimal 20 | Batas input AI |
| 4 | Pengguna memiliki akses internet yang stabil | Sistem berbasis web |

## 14.2 Dependencies

| No | Dependency | Keterangan |
|----|------------|------------|
| 1 | AI API (OpenAI/Gemini) | Untuk fitur AI Resolve, Explain, Query |
| 2 | Email Service | Untuk notifikasi email |
| 3 | Hosting | Untuk deploy aplikasi |

---

# 15. Open Questions

| No | Pertanyaan | Pihak yang Dituju |
|----|------------|-------------------|
| 1 | Berapa batas maksimal jam mengajar per hari untuk guru? | Sekolah |
| 2 | Apakah ada mata pelajaran yang wajib diambil oleh semua siswa? | Kurikulum |
| 3 | Bagaimana proses jika ada guru baru ditengah semester? | Sekolah |
| 4 | Apakah ada fitur cetak jadwal dalam bentuk fisik? | Sekolah |
| 5 | Berapa lama jadwal disimpan dalam sistem? | Sekolah |

---

# Lampiran

## A. Glossary

| Istilah | Definisi |
|---------|----------|
| JP | Jam Pelajaran (satuan waktu mengajar) |
| Plotting | Penugasan guru ke mata pelajaran tertentu |
| Sinkronisasi | Proses menyatukan seluruh jadwal jurusan dan mendeteksi konflik |
| Konflik | Ketidaksesuaian jadwal yang melanggar business rules |
| Koordinator Mapel | Guru yang ditunjuk untuk mengkoordinasi mata pelajaran tertentu |
| DSS | Decision Support System |

## B. Referensi

- Standar Nasional Pendidikan (SNP)
- Kurikulum SMK 2024/2025
- Peraturan Menteri Pendidikan tentang Jam Pelajaran
