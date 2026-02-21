.PHONY: help install lint lint-fix format format-check lint-notebooks test check clean pre-commit-install labels

# Default target
help:
	@echo "High-Performance PySpark - Makefile Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make install              Install project dependencies with Pipenv"
	@echo "  make pre-commit-install   Install pre-commit git hooks"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint                 Run ruff linter on tests/"
	@echo "  make lint-fix             Run ruff with auto-fix"
	@echo "  make format-check         Check code formatting"
	@echo "  make format               Auto-format code"
	@echo "  make lint-notebooks       Run ruff on notebook cells via nbqa"
	@echo "  make test                 Run pytest"
	@echo "  make check                Run all checks (lint, format, test)"
	@echo ""
	@echo "Utilities:"
	@echo "  make labels               Sync GitHub labels from .github/labels.yml"
	@echo "  make clean                Remove generated files, caches, etc."

# ============================================================================
# Installation
# ============================================================================

install:
	pipenv sync --dev
	@echo ""
	@echo "Dependencies installed successfully"

pre-commit-install:
	pipenv run pre-commit install
	@echo ""
	@echo "Pre-commit hooks installed"

# ============================================================================
# Code Quality
# ============================================================================

lint:
	pipenv run ruff check tests/

lint-fix:
	pipenv run ruff check --fix tests/

format-check:
	pipenv run ruff format --check tests/

format:
	pipenv run ruff format tests/

lint-notebooks:
	pipenv run nbqa ruff notebooks/

test:
	pipenv run pytest

# Run all checks (lint + format + test)
check: lint format-check test
	@echo ""
	@echo "All checks passed"

# ============================================================================
# Utilities
# ============================================================================

labels:
	@echo "Syncing labels from .github/labels.yml..."
	@while IFS= read -r name && IFS= read -r color && IFS= read -r desc && IFS= read -r blank; do \
		name=$$(echo "$$name" | sed 's/- name: //'); \
		color=$$(echo "$$color" | sed 's/  color: "//;s/"//g'); \
		desc=$$(echo "$$desc" | sed 's/  description: //'); \
		gh label create "$$name" --description "$$desc" --color "$$color" --force 2>/dev/null || true; \
	done < .github/labels.yml
	@echo ""
	@echo "Labels synced"

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "metastore_db" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "derby.log" -delete 2>/dev/null || true
	rm -rf .logs/ 2>/dev/null || true
	rm -rf notebooks/output/ 2>/dev/null || true
	@echo ""
	@echo "Clean complete"
