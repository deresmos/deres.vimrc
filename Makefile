.PHONY: FORCE
MAKE = make -s
LINK_CMD = $(MAKE) link SRC=$<
LINK_S_CMD = $(LINK_CMD) DEST=$<
CREATE_DIR = [ -d $$DIR_PATH ] || (mkdir -p $$DIR_PATH && echo 'Created directory')

symbolic: FORCE
	bash setup.sh

install: FORCE
	@echo '----- START: Create all symbolic link -----'
	@$(MAKE) all
	@echo '-----  END: Created all symbolic link -----'

all: symbolic setup

setup: FORCE
	cd setup-scripts && bash inst-all.sh

pip: FORCE
	bash ./setup-scripts/inst-pip-package.sh

make-dein: FORCE
	cd ./vplug-factory && cargo run make -p ../plugins ../dein
