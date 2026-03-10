SHELL := /usr/bin/env bash

.PHONY: clean

clean:
	@rm -rf "$(HOME)/.cache/nvim"
	@rm -rf "$(HOME)/.local/state/nvim"
	@rm -rf "$(HOME)/.local/share/nvim"
	@rm -f lazy-lock.json
	@echo "Cleaned Neovim cache, state, and data directories"

