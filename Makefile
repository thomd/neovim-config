SHELL   := /usr/bin/env bash
ROOT    := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
NVIM    := nvim --headless -Es -u $(ROOT)/init.lua

.PHONY: clean

clean:
	@rm -rf "$(HOME)/.cache/nvim"
	@rm -rf "$(HOME)/.local/state/nvim"
	@rm -rf "$(HOME)/.local/share/nvim"
	@echo "Cleaned Neovim cache, state, and data directories"

