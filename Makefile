DOCKER?=$(shell command -v docker 2>/dev/null)
HUGO?=$(shell command -v hugo 2>/dev/null)
HUGO_CMD_VER:=$(shell [ -x "$(HUGO)" ] && echo "$$($(HUGO) version | awk '{print $$2}')" || echo "0")
HUGO_VERSION?=v0.142.0
HUGO_CONTAINER?=ghcr.io/gohugoio/hugo:$(HUGO_VERSION)
ifneq "$(HUGO_CMD_VER)" "$(HUGO_VERSION)"
	ifneq "$(strip $(DOCKER))" ""
		HUGO=docker run --rm --net host \
			-v "$(shell pwd):/project" \
			-u "$(shell id -u):$(shell id -g)" \
			$(HUGO_CONTAINER)
	endif
endif
MARKDOWN_LINT_VER?=v0.17.2
VER_BUMP?=$(shell command -v version-bump 2>/dev/null)
VER_BUMP_CONTAINER?=sudobmitch/version-bump:edge
ifeq "$(strip $(VER_BUMP))" ''
	VER_BUMP=docker run --rm \
		-v "$(shell pwd)/:$(shell pwd)/" -w "$(shell pwd)" \
		-u "$(shell id -u):$(shell id -g)" \
		$(VER_BUMP_CONTAINER)
endif

.PHONY: all .FORCE
all: public

.PHONY: public
public: ## Build public site
	$(HUGO) build

.PHONY: serve
serve: ## Run development site
	$(HUGO) serve -D

.PHONY: theme
theme: ## Refresh submodules, including themes
	git submodule update --init --recursive

.PHONY: lint
lint: lint-md ## Run all linting

.PHONY: lint-md
lint-md: ## Run linting for markdown
	docker run --rm -v "$(PWD):/workdir:ro" davidanson/markdownlint-cli2:$(MARKDOWN_LINT_VER) \
	  "**/*.md" "#public" "#themes"

.PHONY: cli-docs
cli-docs: $(addprefix cli-docs-,$(CLI_CMDS)) ## Update CLI documentation

cli-docs-%: .FORCE
	cd "content/cli/$*" \
	&& go run ../../../tools/generate-cli-docs/generate-cli-docs.go "$*"

.PHONY: util-version-check
util-version-check: ## check all dependencies for updates
	$(VER_BUMP) check

.PHONY: util-version-update
util-version-update: ## update versions on all dependencies
	$(VER_BUMP) update

.PHONY: clean
clean:
	rm -rf themes public

.PHONY: help
help: # Display help
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)
