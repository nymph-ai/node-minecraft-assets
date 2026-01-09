.PHONY: publish publish-provenance release

ENV_FILE := .env
NPM_TOKEN := $(shell if [ -f $(ENV_FILE) ]; then awk -F= '/^NPM_TOKEN=/{print $$2}' $(ENV_FILE) | sed -e 's/^"//' -e 's/"$$//' -e "s/^'//" -e "s/'$$//"; fi)
NPM_TOKEN := $(if $(filter undefined,$(NPM_TOKEN)),,$(NPM_TOKEN))

publish:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo ".env is required in this directory" >&2; \
		exit 1; \
	fi
	@if [ -z "$(NPM_TOKEN)" ]; then \
		echo "Set NPM_TOKEN in .env" >&2; \
		exit 1; \
	fi
	NPM_TOKEN="$(NPM_TOKEN)" npm publish --access public

publish-provenance:
	$(MAKE) publish

release:
	@if [ -z "$(MC_VERSION)" ]; then \
		echo "Set MC_VERSION=1.21.11 (or similar)" >&2; \
		exit 1; \
	fi
	bash scripts/bump-nymph-version.sh "$(MC_VERSION)"
