all:
	eza zsh-autosuggestions zsh-syntax-highlighting nvim tree direnv delta bat

bat:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
	tar -zxvf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
	mv bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz bat.tar.gz
	mv bat-v0.24.0-x86_64-unknown-linux-gnu bat
	ln -snvf $(HOME)/env/bat/bat $(HOME)/.local/sbin/bat

eza:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
	chmod +x eza
	ln -snvf $(HOME)/env/eza $(HOME)/.local/sbin/eza

zsh-autosuggestions:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && git clone https://github.com/zsh-users/zsh-autosuggestions
	ln -snvf $(HOME)/env/zsh-autosuggestions $(HOME)/.local/sbin/zsh-autosuggestions

zsh-syntax-highlighting:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
	ln -snvf $(HOME)/env/zsh-syntax-highlighting $(HOME)/.local/sbin/zsh-syntax-highlighting

nvim:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	tar -zxvf nvim-linux64.tar.gz
	mv nvim-linux64.tar.gz nvim.tar.gz
	mv nvim-linux64 nvim
	ln -snvf $(HOME)/env/nvim/bin/nvim $(HOME)/.local/sbin/nvim

tree:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && git clone https://github.com/Old-Man-Programmer/tree.git
	ln -snvf $(HOME)/env/tree/tree $(HOME)/.local/sbin

direnv:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && git clone https://github.com/direnv/direnv.git
	cd direnv && bash install.sh
	direnv allow

delta:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && wget https://github.com/dandavison/delta/releases/download/0.15.0/delta-0.15.0-x86_64-unknown-linux-musl.tar.gz
	tar -zxvf delta-0.15.0-x86_64-unknown-linux-musl.tar.gz
	mv delta-0.15.0-x86_64-unknown-linux-musl.tar.gz delta.tar.gz
	mv delta-0.15.0-x86_64-unknown-linux-musl delta
	ln -snvf $(HOME)/env/delta/delta $(HOME)/.local/sbin/delta
