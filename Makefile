.DEFAULT_GOAL:=help

.PHONY: dev
dev: ## Installs adapter in develop mode along with development dependencies
	@\
	pip install -r dev_requirements.txt && pre-commit install

.PHONY: mypy
mypy: ## Runs mypy against staged changes for static type checking.
	@\
	pre-commit run --hook-stage manual mypy-check | grep -v "INFO"

.PHONY: flake8
flake8: ## Runs flake8 against staged changes to enforce style guide.
	@\
	pre-commit run --hook-stage manual flake8-check | grep -v "INFO"

.PHONY: black
black: ## Runs black  against staged changes to enforce style guide.
	@\
	pre-commit run --hook-stage manual black-check -v | grep -v "INFO"

.PHONY: lint
lint: ## Runs flake8 and mypy code checks against staged changes.
	@\
	pre-commit run flake8-check --hook-stage manual | grep -v "INFO"; \
	pre-commit run mypy-check --hook-stage manual | grep -v "INFO"

.PHONY: all
all: ## Runs all checks against staged changes.
	@\
	pre-commit run -a

.PHONY: linecheck
linecheck: ## Checks for all Python lines 100 characters or more
	@\
	find dbt -type f -name "*.py" -exec grep -I -r -n '.\{100\}' {} \;

.PHONY: functional
functional: ## Runs functional tests.
	@\
	pytest -n auto -ra -v tests/functional

.PHONY: clean
	@echo "cleaning repo"
	@git clean -f -X

.PHONY: help
help: ## Show this help message.
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@grep -E '^[7+a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
