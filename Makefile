DOTFILES = dotfiles

tangle:
	./emacs-batch-tangle.sh init.org

install:
	bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh;)"
copy:
	cp -i $(DOTFILES)/.bashrc ~/.bashrc


