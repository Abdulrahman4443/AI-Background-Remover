# Changelog

All notable changes to this project are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Planned
- Video background removal
- Mobile application
- AI Smart Edge Refinement model (hair / fur / fine detail)
- Multiple-object detection and per-object segmentation masks
- AI image upscaling (2× / 4×)
- AI image similarity search with vector database
- Edge decontamination (remove background colour fringing)
- Advanced shadow detection and preservation

---

## [2.0.0] — 2026-09-01

Major release. Rewrote the entire backend and frontend. Moved from a simple
4-route prototype to a full-featured production application.

### Added — Backend
- Full JWT authentication with httpOnly refresh cookies and automatic token rotation
- User registration and login (`/api/auth/register`, `/api/auth/login`, `/api/auth/logout`, `/api/auth/refresh`)
- Per-user daily quota system with MongoDB TTL auto-reset
- Image enhancement route (`/api/enhance`) — brightness, contrast, saturation, sharpness, denoise, auto white-balance
- Background replacement route (`/api/replace-bg`) — solid colour, gradient, custom image, photo library
- Smart crop route (`/api/smart-crop`) — AI-guided subject-aware crop
- Recolor & eraser route (`/api/recolor`)
- Inpainting route (`/api/inpaint`)
- Vectorize route (`/api/vectorize`) — PNG to SVG
- Batch processing route (`/api/batch`) — multi-file, quota-aware, async job queue
- AI chatbot route (`/api/chat`) — vision-aware, action-payload extraction (Gemini / Groq)
- AI image analysis route (`/api/ai/analyze`) — quality scores, colour palette, editing recommendations
- Usage stats route (`/api/stats`)
- Analytics event tracking (`/api/analytics`)
- Action history and undo tracking (`/api/action-history`)
- Collaboration routes (`/api/collab/*`)
- User-saved prompt templates (`/api/prompts`)
- S3-compatible cloud storage backend (AWS S3, Cloudflare R2, MinIO)
- Automatic file cleanup background task (configurable TTL)
- Async job queue for heavy tasks
- Structured logging with loguru
- Background-warm-up of all AI model sessions at startup (eliminates first-request delay)

### Added — AI Pipeline
- Three-backend inference system: `rembg` (default), `onnx`, `torch`
- Three quality tiers for rembg: `fast` (ISNet), `standard` (U²-Net portrait), `quality` (BiRefNet)
- In-memory inference path — source image bytes go directly to the model, no temp file
- Thread-safe session cache — model loaded once, reused for all requests
- Advanced post-processing: morphological refinement + guided filter matting + bilateral smoothing
- Optional closed-form alpha matting via pymatting for maximum edge quality
- Image quality analysis (`quality_analysis.py`) — resolution, blur, noise, lighting, compression scoring
- `warm_up_models()` pre-loader called at FastAPI startup

### Added — Frontend
- Complete authentication flow: login, register, forgot password, reset password
- JWT storage in localStorage with 401 interceptor and automatic silent refresh
- 15 lazy-loaded pages: Home, Enhance, ReplaceBg, RecolorAndEraser, SmartCrop, Batch, Shadow, History, Settings, AIAnalysis, and auth pages
- Before/after comparison image canvas
- Advanced editor modal with brush erase / restore
- Background picker: solid colour, gradient, photo library, custom upload
- Quality tier selector (fast / standard / quality)
- History gallery: search, filter, sort, grid / masonry views, multi-select, bulk export as zip
- AI chatbot widget — persistent, vision-aware, emits ACTION payloads to directly apply settings
- AI Analysis page — quality scores, colour palette swatches, editing recommendations, caption generator
- Batch file list with per-file status and progress
- Keyboard shortcuts (`useKeyboardShortcuts` hook)
- Dark / light / system mode with ThemeSettings context
- PWA support (`pwaService.ts`)
- Workspace / Brand Kit context providers
- Toast notification system
- 6 context providers: Auth, ActiveImage, Toast, ThemeSettings, Workspace, BrandKit
- Bottom navigation bar for mobile
- Ambient colour glow effect from extracted image palette

### Changed
- Inference route now uses fully in-memory byte stream — no disk I/O for source image
- All AI-heavy operations moved to thread pool executors (event loop never blocked)
- CORS now driven by `ALLOWED_ORIGINS` env var (comma-separated list)

### Fixed
- Correct Gemini model name (`gemini-2.0-flash` — `gemini-3.6-flash` does not exist)
- `onnxruntime` + `onnxruntime-gpu` install conflict resolved (pick one per environment)
- Dockerfile now copies `AI/` folder correctly (was referencing wrong submodule path)
- Added missing Python packages to `requirements.txt`:
  - `google-generativeai` (Gemini SDK)
  - `openai` (Groq provider)
  - `pymatting` (alpha matting)
  - `boto3` (S3 storage)
  - `dnspython` (MongoDB Atlas SRV)
- Replaced `opencv-python` with `opencv-contrib-python` to include `ximgproc` (guided filter)

### Infrastructure
- Added `docker-compose.yml` — one-command full-stack local setup (frontend + backend + MongoDB)
- Added Dockerfile `HEALTHCHECK` and `USE_GPU` build arg
- Added `Makefile` with developer shortcuts (`make setup`, `make backend`, `make test`, etc.)
- Added GitHub Actions CI workflow — backend (pytest) + frontend (vitest + build) on every push
- Updated all three README files to reflect v2 state

---

## [1.0.0] — 2026-07-01

Initial release. Basic background removal prototype.

### Added
- FastAPI backend with 4 routes: `POST /api/remove-background`, `GET /api/download/{filename}`, `GET /api/history`, `DELETE /api/image/{id}`
- rembg-based background removal (single quality tier)
- MongoDB history storage
- React frontend: upload zone, result display, download button, history page
- Dark mode toggle
