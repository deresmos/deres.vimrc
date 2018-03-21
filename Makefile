MAKE = make -s
LINK_CMD = $(MAKE) link SRC=$<
LINK_S_CMD = $(LINK_CMD) DEST=$<
CREATE_DIR = [ -d $$DIR_PATH ] || (mkdir -p $$DIR_PATH && echo 'Created directory')

symbolic:
	bash setup.sh

install:
	@echo '----- START: Create all symbolic link -----'
	@$(MAKE) all
	@echo '-----  END: Created all symbolic link -----'

all: symbolic setup

setup:
	cd setup-scripts && bash inst-all.sh
