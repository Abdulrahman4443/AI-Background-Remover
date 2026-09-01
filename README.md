# AI Background Remover

> **Organization:** [QuantumLogics Labs](https://github.com/QuantumLogicsLabs)
> **Status:** Active development — v2 in production

---

## What This Project Is

A full-stack AI web application that removes image backgrounds automatically and provides a complete suite of AI-powered image editing tools. A user uploads a photo, the AI isolates the subject, and the app returns a transparent PNG — no manual masking needed.

**Who it is for:** photographers, designers, e-commerce sellers, content creators.

---

## Feature Set (v2)

| Feature | Status |
|---|---|
| AI background removal (3 quality tiers) | ✅ Done |
| JWT authentication + refresh tokens | ✅ Done |
| User registration & login | ✅ Done |
| Image enhancement (brightness, contrast, saturation, etc.) | ✅ Done |
| Background replacement (solid, gradient, image, library) | ✅ Done |
| Smart crop (AI-guided aspect ratio crop) | ✅ Done |
| Recolor & eraser tools | ✅ Done |
| Batch processing (multi-file, quota-aware) | ✅ Done |
| Shadow studio | ✅ Done |
| Inpainting | ✅ Done |
| Vectorize (PNG → SVG) | ✅ Done |
| History gallery (filter, sort, search, bulk export) | ✅ Done |
| AI chatbot (Gemini / Groq, vision-aware) | ✅ Done |
| AI image analysis (quality scores, palette, recommendations) | ✅ Done |
| Per-user daily quota system | ✅ Done |
| Action history & undo tracking | ✅ Done |
| Analytics & usage tracking | ✅ Done |
| Collaboration routes | ✅ Done |
| S3-compatible cloud storage | ✅ Done |
| Dark / light mode | ✅ Done |
| PWA support | ✅ Done |
| Keyboard shortcuts | ✅ Done |
| Docker + docker-compose | ✅ Done |
| Video background removal | 🔜 Planned |
| Mobile app | 🔜 Planned |

---

## Repository Structure

This is the **parent repository**. It ties together three independent submodule repositories and holds shared configuration.

```
AI-Background-Remover/          ← you are here (parent repo)
│
├── frontend/                   ← submodule → AI-Background-Remover-frontend
│   React 18 + TypeScript + Tailwind CSS + Vite 5
│   Owned by: Web Team (UI)
│
├── backend/                    ← submodule → AI-Background-Remover-backend
│   Python 3.11 + FastAPI + MongoDB (Motor) + JWT auth
│   Owned by: Web Team (API)
│
├── AI/                         ← submodule → AI-Background-Remover-AI
│   rembg / ONNX / PyTorch inference pipeline
│   Owned by: AI Team + ML Team
│
├── docker-compose.yml          ← one-command full-stack local setup
├── Dockerfile                  ← containerises backend + AI together
├── requirements.txt            ← Python deps for backend + AI combined
├── .env.example                ← all environment variables documented
└── CHANGELOG.md                ← version history
```

---

## Three Teams, One Product

| Team | Repo | What They Build |
|---|---|---|
| **Web Team (UI)** | `frontend` | React UI — upload, preview, compare, download, history, settings |
| **Web Team (API)** | `backend` | FastAPI — 20+ REST endpoints, MongoDB, JWT auth, quotas, storage |
| **AI Team** | `AI` | Inference pipeline — preprocessing, model execution, postprocessing |
| **ML Team** | `AI` | Model research — evaluate U²-Net, BiRefNet, train/export weights |

---

## Full Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | React 18 + TypeScript 5 |
| Styling | Tailwind CSS 3 + CSS custom properties |
| Build Tool | Vite 5 |
| HTTP Client | Axios (with 401 interceptor + token refresh) |
| File Upload | react-dropzone |
| Routing | react-router-dom v6 |
| API Framework | FastAPI 0.115 |
| ASGI Server | Uvicorn |
| Database | MongoDB 7 (async via Motor) |
| Auth | JWT (python-jose) + bcrypt (passlib) + httpOnly refresh cookies |
| AI Inference | rembg (ISNet / U²-Net / BiRefNet) + ONNX Runtime + PyTorch 2.3 |
| Image Processing | OpenCV-contrib + Pillow + NumPy + scikit-image + pymatting |
| AI Chat / Analysis | Google Gemini 2.0 (default) or Groq (llama-3.3-70b) |
| Cloud Storage | Local disk (default) or S3-compatible (AWS / Cloudflare R2 / MinIO) |
| Deployment | Vercel (frontend) + Docker (backend + AI) |

---

## Local Setup (Full Stack)

### Prerequisites
- Python 3.11+
- Node.js 20+
- MongoDB running locally on port 27017 **or** use Docker Compose (see below)

### Option A — Docker Compose (recommended, zero config)

```bash
git clone --recurse-submodules https://github.com/QuantumLogicsLabs/AI-Background-Remover.git
cd AI-Background-Remover

# Copy backend env and fill in your API keys
cp backend/.env.example backend/.env
# Edit backend/.env — set GEMINI_API_KEY (or GROQ_API_KEY) and SECRET_KEY

docker compose up
```

- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- Swagger docs: http://localhost:8000/docs

> First run downloads rembg model weights (~500 MB). Subsequent runs use the cache.

---

### Option B — Manual

#### Step 1 — Clone with submodules
```bash
git clone --recurse-submodules https://github.com/QuantumLogicsLabs/AI-Background-Remover.git
cd AI-Background-Remover
```

If you already cloned without `--recurse-submodules`:
```bash
git submodule update --init --recursive
```

#### Step 2 — Python environment
```bash
python -m venv .venv
.venv\Scripts\activate          # Windows
# source .venv/bin/activate     # Mac/Linux

pip install -r requirements.txt
```

#### Step 3 — Environment files
```bash
cp backend/.env.example backend/.env
cp AI/.env.example AI/.env
```

Edit `backend/.env`:
- Set `SECRET_KEY` to a random 32-byte hex string: `python -c "import secrets; print(secrets.token_hex(32))"`
- Set `GEMINI_API_KEY` (get one free at https://aistudio.google.com/app/apikey)
- Set `MONGO_URI` if MongoDB is not on localhost

#### Step 4 — Run the backend
```bash
cd backend
uvicorn app:app --reload --port 8000
```

Swagger UI: http://localhost:8000/docs

#### Step 5 — Run the frontend
```bash
cd frontend
npm install
npm run dev
```

App: http://localhost:5173

---

## API Endpoints (Summary)

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/auth/register` | Register a new user |
| `POST` | `/api/auth/login` | Login, receive JWT + refresh cookie |
| `POST` | `/api/auth/logout` | Logout, clear refresh cookie |
| `POST` | `/api/auth/refresh` | Refresh access token via httpOnly cookie |
| `POST` | `/api/remove-background` | Upload image, get transparent PNG |
| `POST` | `/api/enhance` | Enhance image (brightness, contrast, etc.) |
| `POST` | `/api/replace-bg` | Replace background with colour / image |
| `POST` | `/api/smart-crop` | AI-guided smart crop |
| `POST` | `/api/recolor` | Recolor objects in image |
| `POST` | `/api/inpaint` | Inpaint / erase regions |
| `POST` | `/api/vectorize` | Convert PNG to SVG |
| `POST` | `/api/batch` | Batch-process multiple images |
| `GET` | `/api/download/{filename}` | Download a processed image |
| `GET` | `/api/history` | Get current user's processing history |
| `GET` | `/api/history/all` | Admin — all history records |
| `DELETE` | `/api/image/{id}` | Delete image from storage + history |
| `POST` | `/api/chat` | AI chatbot (vision-aware) |
| `POST` | `/api/ai/analyze` | AI image analysis |
| `GET` | `/api/stats` | Usage stats for current user |
| `GET` | `/api/analytics` | Analytics events |
| `GET` | `/` | Health check |

Full interactive docs: http://localhost:8000/docs

---

## AI Quality Tiers

| Tier | Model | Best For | Speed |
|---|---|---|---|
| `fast` | ISNet-general-use | Products, objects, general use | ~1–2 s |
| `standard` | U²-Net human seg | Portraits, people, faces | ~2–3 s |
| `quality` | BiRefNet-general | Hair, fur, complex edges | ~4–6 s |

---

## AI Pipeline

```
User uploads image
        │
        ▼
  [Backend] Validate + quota check
        │
        ▼
  [AI] Preprocessing — resize 1024×1024, ImageNet normalise
        │
        ▼
  [AI] Inference — rembg / ONNX / PyTorch
        │
        ▼
  [AI] Postprocessing — upsample mask → morphological refinement
                      → guided filter matting → transparent PNG
        │
        ▼
  [Backend] Save to storage, write history, return download URL
        │
        ▼
  [Frontend] Before/after slider, download, edit further
```

---

## Environment Variables

All variables are documented in `.env.example` at the repo root and in each submodule's `.env.example`.

**Key variables to set before running:**

| Variable | File | Description |
|---|---|---|
| `SECRET_KEY` | `backend/.env` | JWT signing secret — generate with `secrets.token_hex(32)` |
| `GEMINI_API_KEY` | `backend/.env` | Google Gemini API key (free tier available) |
| `MONGO_URI` | `backend/.env` | MongoDB connection string |
| `ALLOWED_ORIGINS` | `backend/.env` | Comma-separated frontend URLs for CORS |

---

## Deployment

| Service | What it hosts |
|---|---|
| Vercel | `frontend/` — auto-deploy on push to `main` |
| Docker | `backend/` + `AI/` — via Dockerfile or docker-compose |

```bash
# Build and run backend + AI with Docker
docker build -t ai-bg-remover .
docker run -p 8000:8000 --env-file backend/.env ai-bg-remover

# Or use compose for the full stack
docker compose up --build
```

---

## Submodule Workflow

```bash
# Update a submodule after a teammate pushes to it
cd frontend           # or backend / AI
git pull origin main

# Back in the parent repo — record the new submodule commit
cd ..
git add frontend
git commit -m "chore: update frontend submodule pointer"
git push
```

---

## Links

| Resource | URL |
|---|---|
| Parent repo | github.com/QuantumLogicsLabs/AI-Background-Remover |
| Frontend repo | github.com/QuantumLogicsLabs/AI-Background-Remover-frontend |
| Backend repo | github.com/QuantumLogicsLabs/AI-Background-Remover-backend |
| AI repo | github.com/QuantumLogicsLabs/AI-Background-Remover-AI |
| Changelog | [CHANGELOG.md](./CHANGELOG.md) |
| Contributing | [CONTRIBUTING.md](./CONTRIBUTING.md) |
