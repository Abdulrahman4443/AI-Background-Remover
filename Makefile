# ============================================================
# AI Background Remover — Developer Makefile
#
# Prerequisites:
#   Python 3.11+  (with .venv created at repo root)
#   Node.js 20+
#   MongoDB (local or via `make docker-mongo`)
#
# Typical first-time setup:
#   make setup
#   make dev
# ============================================================

# ── Config ────────────────────────────────────────────────────
PYTHON      := .venv/Scripts/python     # Windows (.venv\Scripts\python.exe)
PIP         := .venv/Scripts/pip
UVICORN     := .venv/Scripts/uvicorn
PYTEST      := .venv/Scripts/pytest
NODE        := node
NPM         := npm

# Detect OS and adjust paths for Mac/Linux
ifeq ($(OS),Windows_NT)
    PYTHON  := .venv\Scripts\python
    PIP     := .venv\Scripts\pip
    UVICORN := .venv\Scripts\uvicorn
    PYTEST  := .venv\Scripts\pytest
    ACTIVATE := .venv\Scripts\activate
else
    PYTHON  := .venv/bin/python
    PIP     := .venv/bin/pip
    UVICORN := .venv/bin/uvicorn
    PYTEST  := .venv/bin/pytest
    ACTIVATE := source .venv/bin/activate
endif

.DEFAULT_GOAL := help

# ── Help ──────────────────────────────────────────────────────
.PHONY: help
help:
	@echo ""
	@echo "  AI Background Remover — Available commands"
	@echo "  ─────────────────────────────────────────────────────"
	@echo "  Setup"
	@echo "    make setup           Full first-time setup (venv + pip + npm)"
	@echo "    make install         Install/update all Python + Node deps"
	@echo "    make install-python  Install Python deps only"
	@echo "    make install-node    Install Node deps only"
	@echo "    make env             Copy .env.example files (won't overwrite)"
	@echo ""
	@echo "  Development"
	@echo "    make backend         Start FastAPI backend (port 8000, hot-reload)"
	@echo "    make frontend        Start Vite dev server (port 5173)"
	@echo "    make dev             Start backend + frontend (requires two terminals)"
	@echo ""
	@echo "  Docker"
	@echo "    make docker-up       Start full stack via docker compose"
	@echo "    make docker-down     Stop and remove containers"
	@echo "    make docker-build    Rebuild Docker images"
	@echo "    make docker-mongo    Start only MongoDB in Docker"
	@echo "    make docker-logs     Tail logs from all services"
	@echo ""
	@echo "  Testing"
	@echo "    make test            Run all tests (backend + frontend)"
	@echo "    make test-backend    Run backend pytest suite"
	@echo "    make test-frontend   Run frontend Vitest suite"
	@echo ""
	@echo "  Code Quality"
	@echo "    make lint            Lint backend (ruff) + frontend (eslint)"
	@echo "    make lint-backend    Lint Python with ruff"
	@echo "    make lint-frontend   Lint TypeScript/React with eslint"
	@echo "    make format          Auto-format backend with ruff"
	@echo ""
	@echo "  Utilities"
	@echo "    make secret          Generate a secure SECRET_KEY value"
	@echo "    make clean           Remove build artifacts and cache files"
	@echo "    make clean-output    Delete processed images from output/"
	@echo ""

# ── Setup ─────────────────────────────────────────────────────
.PHONY: setup
setup: venv install-python install-node env
	@echo ""
	@echo "  Setup complete!"
	@echo "  Next: edit backend/.env and set SECRET_KEY + GEMINI_API_KEY"
	@echo "  Then: make backend  (in one terminal)"
	@echo "        make frontend (in another terminal)"
	@echo ""

.PHONY: venv
venv:
	@echo "Creating Python virtual environment..."
	python -m venv .venv
	@echo "Virtual environment created at .venv/"

.PHONY: install
install: install-python install-node

.PHONY: install-python
install-python:
	@echo "Installing Python dependencies..."
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

.PHONY: install-node
install-node:
	@echo "Installing Node.js dependencies..."
	cd frontend && $(NPM) install

.PHONY: env
env:
	@echo "Copying .env.example files (skipping any that already exist)..."
	@if not exist backend\.env copy backend\.env.example backend\.env
	@if not exist AI\.env     copy AI\.env.example     AI\.env
	@if not exist frontend\.env copy frontend\.env.example frontend\.env
	@echo "Done. Edit backend/.env and set your SECRET_KEY and API keys."

# ── Development ───────────────────────────────────────────────
.PHONY: backend
backend:
	@echo "Starting FastAPI backend on http://localhost:8000 ..."
	cd backend && $(UVICORN) app:app --reload --port 8000

.PHONY: frontend
frontend:
	@echo "Starting Vite dev server on http://localhost:5173 ..."
	cd frontend && $(NPM) run dev

.PHONY: dev
dev:
	@echo ""
	@echo "  Run these two commands in separate terminals:"
	@echo "    make backend"
	@echo "    make frontend"
	@echo ""
	@echo "  Or use:  make docker-up  to start everything via Docker."
	@echo ""

# ── Docker ────────────────────────────────────────────────────
.PHONY: docker-up
docker-up:
	docker compose up

.PHONY: docker-up-detached
docker-up-detached:
	docker compose up -d

.PHONY: docker-down
docker-down:
	docker compose down

.PHONY: docker-build
docker-build:
	docker compose build

.PHONY: docker-mongo
docker-mongo:
	docker compose up mongo -d
	@echo "MongoDB running on localhost:27017"

.PHONY: docker-logs
docker-logs:
	docker compose logs -f

# ── Testing ───────────────────────────────────────────────────
.PHONY: test
test: test-backend test-frontend

.PHONY: test-backend
test-backend:
	@echo "Running backend tests..."
	cd backend && $(PYTEST) -v

.PHONY: test-frontend
test-frontend:
	@echo "Running frontend tests..."
	cd frontend && $(NPM) test

# ── Code Quality ──────────────────────────────────────────────
.PHONY: lint
lint: lint-backend lint-frontend

.PHONY: lint-backend
lint-backend:
	@echo "Linting Python with ruff..."
	$(PYTHON) -m ruff check backend/ AI/ || true

.PHONY: lint-frontend
lint-frontend:
	@echo "Linting TypeScript/React with eslint..."
	cd frontend && $(NPM) run lint

.PHONY: format
format:
	@echo "Auto-formatting Python with ruff..."
	$(PYTHON) -m ruff format backend/ AI/

# ── Utilities ─────────────────────────────────────────────────
.PHONY: secret
secret:
	@echo "Generated SECRET_KEY (copy this into backend/.env):"
	@$(PYTHON) -c "import secrets; print(secrets.token_hex(32))"

.PHONY: clean
clean:
	@echo "Cleaning build artifacts and cache files..."
	find . -type d -name "__pycache__"  -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "dist"          -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".vite"         -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc"                 -delete 2>/dev/null || true
	@echo "Clean complete."

.PHONY: clean-output
clean-output:
	@echo "WARNING: This will delete all processed images in output/"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read _
	find backend/output -name "*.png" -delete 2>/dev/null || true
	find output         -name "*.png" -delete 2>/dev/null || true
	@echo "Output directories cleared."
