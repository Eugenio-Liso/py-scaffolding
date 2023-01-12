POETRY_RUN := poetry run
BLUE=\033[0;34m
NC=\033[0m # No Color
REPO_MAIN_FOLDER := "CHANGE ME"

shell: ## Create a shell with all the dependencies needed
	@echo "\n${BLUE}Running poetry shell...${NC}\n"
	poetry shell

update: ## Just update the environment
	@echo "\n${BLUE}Update poetry itself and check...${NC}\n"
	pip3 install --upgrade poetry
	poetry check
	@echo "\n${BLUE}Running poetry update...${NC}\n"
	@${POETRY_RUN} pip install --upgrade pip setuptools
	@${POETRY_RUN} python --version
	poetry update
	@echo "\n${BLUE}Show outdated packages...${NC}\n"
	@${POETRY_RUN} pip list -o --not-required --outdated

autolint: ## Autolinting code
	@echo "\n${BLUE}Running autolinting...${NC}\n"
	@${POETRY_RUN} black --target-version py310 .
	@${POETRY_RUN} isort .
	@${POETRY_RUN} pyupgrade --py310-plus $(shell find $(REPO_MAIN_FOLDER) -name "*.py")

lint-mypy: ## Runs only mypy lint
	@echo "\n${BLUE}Running mypy...${NC}\n"
	@${POETRY_RUN} mypy .

lint-base: lint-mypy ## Autolint and code linting
	@echo "\n${BLUE}Running bandit...${NC}\n"
	@${POETRY_RUN} bandit -c pyproject.toml -r $(REPO_MAIN_FOLDER)
	@echo "\n${BLUE}Running pylint...${NC}\n"
	@${POETRY_RUN} pylint $(REPO_MAIN_FOLDER)

lint: lint-base autolint ## Complete autolint

unit-test: ## Run unit tests.
	@echo "\n${BLUE}Running unit tests...${NC}\n"
	@${POETRY_RUN} pytest tests/unit

integration-test: ## Run integration tests
	@echo "\n${BLUE}Running integration tests...${NC}\n"
	@${POETRY_RUN} pytest tests/integration

coverage: ## Tests coverage
	@echo "\n${BLUE}Running pytest with coverage...${NC}\n"
	@${POETRY_RUN} coverage erase;
	@${POETRY_RUN} coverage run -m pytest tests \
		--junitxml=junit/test-results.xml \
		--verbose \
		-s \
		-vv
	@${POETRY_RUN} coverage report
	@${POETRY_RUN} coverage html
	@${POETRY_RUN} coverage xml

test: unit-test integration-test coverage ## Run all tests

serve-coverage: ## Start a local server to show the HTML code coverage report
	@echo "\n${BLUE}Open http://localhost:8000/ \n\nKill with CTRL+C${NC}\n"
	@echo "Starting server..."
	@cd "htmlcov"; ${POETRY_RUN} python -m http.server

clean: ## Force a clean environment: remove all temporary files and caches. Start from a new environment
	@echo "\n${BLUE}Cleaning up...${NC}\n"
	rm -rf .mypy_cache .pytest_cache htmlcov junit coverage.xml .coverage
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	@echo "\n${BLUE}Removing poetry environment...${NC}\n"
	poetry env list
	poetry env info -p
	poetry env remove $(shell poetry run which python)
	poetry env list

recreate-local-dockers: ## For local testing
	docker-compose down --volumes
	docker-compose build && docker-compose up

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'