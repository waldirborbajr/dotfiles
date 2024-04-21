cargo install ripgrep
cargo install --locked bat
cargo install xh --locked
cargo install fd-find
cargo install --locked zellij
cargo install alacritty
cargo install eza
cargo install exa
cargo install bottom
cargo install cargo-cache
cargo install zoxide --locked
cargo install lsd
cargo install du-dust

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install

git clone https://github.com/muesli/duf.git
cd duf
go build
go install

go install github.com/goreleaser/goreleaser@latest
