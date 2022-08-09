.PHONY: help setup copy-envs test lint pre-commit run-local report clean makemigration-local migrate-local requirements

PROJECT_NAME := auth-api-django

help: ## Show help.
	@printf "A set of development commands.\n"
	@printf "\nUsage:\n"
	@printf "\t make \033[36m<commands>\033[0m\n"
	@printf "\nThe Commands are:\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## Setup poetry environment
	poetry shell
	poetry install

copy-envs: ## Create secret file
	@cp -n .example.secret.toml .secret.toml

test: ## Run tests locally
	poetry run pytest --cov=src --color=yes tests/

lint | pre-commit: ## Run the pre-commit config
	poetry run pre-commit run -a

run-local: ## Run server locally
	python ./src/manage.py runserver

report: test ## Create test report
	pytest --cov=$(API_CONTAINER_NAME) --color=yes tests/
	coverage report
	coverage html -d coverage_html

clean: ## Clean up
	@find ./ -name '*.pyc' -exec rm -f {} \;
	@find ./ -name 'Thumbs.db' -exec rm -f {} \;
	@find ./ -name '*~' -exec rm -f {} \;
	rm -rf .coverage
	rm -rf  coverage_html
	rm -rf .pytest_cache
	rm -rf .cache
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info
	rm -rf htmlcov
	rm -rf .tox/
	rm -rf docs/_build
	rm -rf celerybeat-schedule
	rm -rf *.pyc
	rm -rf *__pycache__

makemigration-local: ## Database migration locally
	python ./src/manage.py makemigrations

migrate-local: ## Database migrate locally
	python ./src/manage.py migrate

requirements: ## Export requirements file based on poetry packages
	poetry export -f requirements.txt --output requirements.txt --without-hashes
