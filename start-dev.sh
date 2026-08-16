#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

echo "============================================"
echo " Grafika Intelligent Scheduling - Dev Mode"
echo "============================================"
echo ""

# Check .env
if [ ! -f .env ]; then
  echo "[INFO] Membuat .env dari .env.example..."
  cp .env.example .env
  echo "[WARN] Edit .env dan isi OPENAI_API_KEY terlebih dahulu!"
fi

# Check submodules
for sub in backend frontend ml; do
  if [ ! -d "$ROOT_DIR/$sub/.git" ]; then
    echo "[ERROR] Submodule '$sub' belum di-clone."
    echo "        Jalankan: git submodule update --init --recursive"
    exit 1
  fi
done
echo "[OK] Semua submodule tersedia."

# Check prerequisites
command -v go >/dev/null 2>&1 || { echo "[ERROR] Golang tidak ditemukan."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "[ERROR] Node.js tidak ditemukan."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "[ERROR] Python3 tidak ditemukan."; exit 1; }
echo "[OK] Semua prerequisite terpenuhi."
echo ""

cleanup() {
  echo ""
  echo "[INFO] Menghentikan semua service..."
  kill $BACKEND_PID $ML_PID $FRONTEND_PID 2>/dev/null
  wait $BACKEND_PID $ML_PID $FRONTEND_PID 2>/dev/null
  echo "[OK] Semua service berhenti."
}
trap cleanup EXIT INT TERM

# ML Service
echo "[ML] Install dependencies..."
cd "$ROOT_DIR/ml"
if [ ! -d venv ]; then
  python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt -q
echo "[ML] Menjalankan ML service di :8000..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
ML_PID=$!
deactivate
cd "$ROOT_DIR"

sleep 3

# Backend
echo "[Backend] Menjalankan Go server di :8080..."
cd "$ROOT_DIR/backend"
go run ./cmd/server &
BACKEND_PID=$!
cd "$ROOT_DIR"

sleep 2

# Frontend
echo "[Frontend] Menjalankan Next.js di :3000..."
cd "$ROOT_DIR/frontend"
npm run dev &
FRONTEND_PID=$!
cd "$ROOT_DIR"

echo ""
echo "============================================"
echo " Semua service sudah di-start:"
echo "   Frontend : http://localhost:3000"
echo "   Backend  : http://localhost:8080"
echo "   ML       : http://localhost:8000"
echo "============================================"
echo ""
echo "Tekan Ctrl+C untuk menghentikan semua service."
wait
