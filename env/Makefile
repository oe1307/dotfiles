link:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/.local/share
	mkdir -p $(HOME)/env
	ln -snvf $(HOME)/env/bat/bat $(HOME)/.local/sbin/bat
	ln -snvf $(HOME)/env/eza $(HOME)/.local/sbin/eza
	ln -snvf $(HOME)/env/zsh-autosuggestions $(HOME)/.local/share/zsh-autosuggestions
	ln -snvf $(HOME)/env/zsh-syntax-highlighting $(HOME)/.local/share/zsh-syntax-highlighting
	ln -snvf $(HOME)/env/zsh-autopair $(HOME)/.local/share/zsh-autopair
	ln -snvf $(HOME)/env/nvim/bin/nvim $(HOME)/.local/sbin/nvim
	ln -snvf $(HOME)/env/tree/tree $(HOME)/.local/sbin
	ln -snvf $(HOME)/env/delta/delta $(HOME)/.local/sbin/delta
	cd $(HOME)/env/direnv && bash install.sh

bat:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	wget -P $(HOME)/env https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
	cd $(HOME)/env && tar -zxvf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
	mv $(HOME)/env/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz $(HOME)/env/bat.tar.gz
	mv $(HOME)/env/bat-v0.24.0-x86_64-unknown-linux-gnu $(HOME)/env/bat
	ln -snvf $(HOME)/env/bat/bat $(HOME)/.local/sbin/bat

trash-cli:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	if hash pip 2>/dev/null; then (pip install trash-cli); else echo "pip not found"; fi

eza:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
	chmod +x $(HOME)/env/eza
	ln -snvf $(HOME)/env/eza $(HOME)/.local/sbin/eza

zsh-autosuggestions:
	mkdir -p $(HOME)/.local/share
	mkdir -p $(HOME)/env
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/env/zsh-autosuggestions
	ln -snvf $(HOME)/env/zsh-autosuggestions $(HOME)/.local/share/zsh-autosuggestions

zsh-syntax-highlighting:
	mkdir -p $(HOME)/.local/share
	mkdir -p $(HOME)/env
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(HOME)/env/zsh-syntax-highlighting
	ln -snvf $(HOME)/env/zsh-syntax-highlighting $(HOME)/.local/share/zsh-syntax-highlighting

zsh-autopair:
	mkdir -p $(HOME)/.local/share
	mkdir -p $(HOME)/env
	git clone https://github.com/hlissner/zsh-autopair.git $(HOME)/env/zsh-autopair
	ln -snvf $(HOME)/env/zsh-autopair $(HOME)/.local/share/zsh-autopair

nvim:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	cd $(HOME)/env && tar -zxvf nvim-linux64.tar.gz
	mv $(HOME)/env/nvim-linux64.tar.gz $(HOME)/env/nvim.tar.gz
	mv $(HOME)/env/nvim-linux64 $(HOME)/env/nvim
	ln -snvf $(HOME)/env/nvim/bin/nvim $(HOME)/.local/sbin/nvim

tree:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	git clone https://github.com/Old-Man-Programmer/tree.git $(HOME)/env/tree
	cd $(HOME)/env/tree && make
	ln -snvf $(HOME)/env/tree/tree $(HOME)/.local/sbin

direnv:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	git clone https://github.com/direnv/direnv.git $(HOME)/env/direnv
	cd $(HOME)/env/direnv && bash install.sh

delta:
	mkdir -p $(HOME)/.local/sbin
	mkdir -p $(HOME)/env
	cd $(HOME)/env && wget https://github.com/dandavison/delta/releases/download/0.15.0/delta-0.15.0-x86_64-unknown-linux-musl.tar.gz
	cd $(HOME)/env && tar -zxvf delta-0.15.0-x86_64-unknown-linux-musl.tar.gz
	mv $(HOME)/env/delta-0.15.0-x86_64-unknown-linux-musl.tar.gz $(HOME)/env/delta.tar.gz
	mv $(HOME)/env/delta-0.15.0-x86_64-unknown-linux-musl $(HOME)/env/delta
	ln -snvf $(HOME)/env/delta/delta $(HOME)/.local/sbin/delta

# zsh:
# 	mkdir -p $(HOME)/.local/sbin
# 	mkdir -p $(HOME)/env

htop:
	git clone https://github.com/htop-dev/htop.git $(HOME)/env/htop
	cd $(HOME)/env && ./autogen.sh && ./configure --disable-unicode && make
	ln -snvf $(HOME)/env/htop/htop $(HOME)/.local/sbin/htop
