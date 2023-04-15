.PHONY: FORCE
MAKE = make -s
LINK_CMD = $(MAKE) link SRC=$<
LINK_S_CMD = $(LINK_CMD) DEST=$<
CREATE_DIR = [ -d $$DIR_PATH ] || (mkdir -p $$DIR_PATH && echo 'Created directory')

setup: FORCE
	bash setup.sh

install: FORCE
	@echo '----- START: Create all symbolic link -----'
	@$(MAKE) all
	@echo '-----  END: Created all symbolic link -----'

update-plugins: FORCE
	cd ../vplug-factory && cargo run make -m packer -p ../neovim/plugins ../neovim/lua/plugins.lua
