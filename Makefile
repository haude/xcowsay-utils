default:
	./main.sh

build:
	@echo "nothing to build"

unlink:
	rm -f /usr/local/bin/xcowsay-utils

uninstall: unlink
	rm -rf /opt/xcowsay-utils

link: unlink
	ln -s "$(PWD)/main.sh" /usr/local/bin/xcowsay-utils

install: unlink uninstall
	mkdir -p /opt/xcowsay-utils
	cp *sh /opt/xcowsay-utils/
	ln -s /opt/xcowsay/main.sh /usr/local/bin/xcowsay-utils

alias:
	@echo "add alias in to '.bashrc'"
	@echo "alias xcowsay-utils='$PWD/main.sh'"
