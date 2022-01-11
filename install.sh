#!/bin/sh

swift build -c release
cd .build/release
cp -f snpm /usr/local/bin/snpm

mkdir -p ~/.zsh/completion
touch ~/.zsh/completion/_snpm.zsh
snpm --generate-completion-script zsh > ~/.zsh/completion/_snpm.zsh
echo 'fpath=(~/.zsh/completion ${fpath})' >> ~/.zshrc
echo 'autoload -U compinit && compinit' >> ~/.zshrc
exec zsh
