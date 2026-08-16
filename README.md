# Grafika Intelligent Scheduling

Platform manajemen jadwal sekolah berbasis AI untuk SMK.

## Tech Stack

- **Frontend**: Next.js 16 + shadcn/ui + Tailwind CSS
- **Backend**: Go 1.23 + GORM + Fiber
- **ML**: Python FastAPI + LangChain + OpenAI
- **Database**: PostgreSQL 16
- **Infra**: Docker Compose

## Struktur Repository

Repositori ini adalah **container repo** — backend, frontend, dan ML service masing-masing
adalah repositori git terpisah yang dilampirkan sebagai **submodule**.

```
grafika-intelligent-scheduling/          ← container repo
├── .gitmodules                          ← definisi submodule
├── docker-compose.yml
├── .env.example
├── backend/             ← submodule → github.com/leandrawisnu/grafika-intelligent-scheduling-backend
│   └── db/init.sql      ← skema database (tabel bahasa Indonesia)
├── frontend/            ← submodule → github.com/leandrawisnu/grafika-intelligent-scheduling-frontend
└── ml/                  ← submodule → github.com/leandrawisnu/grafika-intelligent-scheduling-ml
```

## Setup

```bash
# Clone container repo beserta semua submodule
git clone --recurse-submodules https://github.com/leandrawisnu/grafika-intelligent-scheduling.git
cd grafika-intelligent-scheduling

# Jika sudah ter-clone tanpa --recurse-submodules:
git submodule update --init --recursive

cp .env.example .env
# Edit .env dan isi OPENAI_API_KEY

# Jalankan semua service (Docker)
docker compose up

# Atau jalankan secara individu (per-service, di terminal terpisah):
# Backend (butuh Go 1.23+ dan PostgreSQL berjalan)
cd backend && go run ./cmd/server

# ML service (butuh Python 3.12+)
cd ml && pip install -r requirements.txt && uvicorn app.main:app --reload

# Frontend (butuh Node 20+ / Bun)
cd frontend && bun install && bun run dev
```

### Update submodule

Setiap service repo dikelola secara independen. Setelah ada perubahan di salah satu submodule,
commit pointer-nya di container repo:

```bash
git submodule update --remote   # tarik commit terbaru semua submodule
# atau
cd backend && git pull          # tarik di dalam submodule

# lalu di container repo
git add backend frontend ml
git commit -m "chore: update submodule"
```

## Arsitektur

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Frontend │────→│ Backend  │────→│    ML    │     │PostgreSQL│
│ :3000    │     │ :8080    │     │ :8000    │     │ :5432    │
└──────────┘     └────┬─────┘     └──────────┘     └──────────┘
                      │                                   │
                      └───────────────────────────────────┘
```

### Alur Kerja Utama

1. **Data Master** — Kelola guru, mapel, jurusan, kelas, ruangan, jam pelajaran
2. **Draf Jadwal** — Admin jurusan membuat slot jadwal (tanpa guru)
3. **Penempatan Guru** — Kurikulum menugaskan guru ke setiap slot
4. **Deteksi Konflik** — Backend menjalankan rule engine (bentrok guru, ruangan, kelebihan jam, hari libur, dll)
5. **AI Selesaikan** — ML service memberikan 3 alternatif solusi via LangChain
6. **Publikasi** — Hanya jika bebas konflik

### Endpoint API

Semua path dan response menggunakan bahasa Indonesia:

- `GET /health` — Cek kesehatan
- `GET/POST /api/v1/guru, jurusan, mata-pelajaran, kelas, ruangan, semester, tahun-ajaran, jam-pelajaran` — CRUD data master
- `GET /api/v1/hari` — Hari (terisi otomatis: Senin–Minggu)
- `POST /api/v1/jadwal` — Buat jadwal baru
- `POST /api/v1/jadwal/{id}/validasi` — Deteksi konflik (rule engine)
- `POST /api/v1/jadwal/{id}/prediksi-konflik` — Prediksi AI
- `POST /api/v1/konflik/{id}/selesaikan` — Solusi AI (3 alternatif)
- `POST /api/v1/resolusi/{id}/terima` — Terapkan solusi
- `POST /api/v1/ai/tanya` — Tanya AI bahasa natural
