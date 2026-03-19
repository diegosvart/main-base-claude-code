.PHONY: dev test lint migrate seed clean

# ─── Development ───────────────────────────────
dev:
	uvicorn app.main:app --reload --port 8000

# ─── Quality ───────────────────────────────────
test:
	pytest -xvs --cov=app --cov-report=term-missing

test-unit:
	pytest -xvs tests/unit/

test-integration:
	pytest -xvs tests/integration/

lint:
	ruff check . && ruff format . && mypy app/

format:
	ruff format . && ruff check --fix .

# ─── Database ──────────────────────────────────
migrate:
	alembic upgrade head

migrate-down:
	alembic downgrade -1

migration:
	@read -p "Migration name: " name; \
	alembic revision --autogenerate -m "$$name"

seed:
	python scripts/seed.py

# ─── Utilities ─────────────────────────────────
clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; \
	find . -name "*.pyc" -delete; \
	rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov

audit:
	pip audit

install:
	pip install -r requirements.txt

install-dev:
	pip install -r requirements-dev.txt
