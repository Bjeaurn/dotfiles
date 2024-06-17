#!/usr/bin/env bash

# brew install zsh-syntax-highlighting
# brew install zsh-autosuggestions
# brew install fzf

function installDotfiles() {
  scriptFor "brew"
  scriptFor "git"
  scriptFor "git" "semantic-commits.sh"
  installFor "zsh/zshrc" "zshrc"
  installFor "zsh/p10k.zsh" "p10k.zsh"
  installFor "zsh/environment.sh" "zsh/environment.sh" "zsh"
  installFor "zsh/scripts/" "zsh/scripts/" "zsh/"
  installFor "zsh/.config/" "zsh/.config/" "zsh/"
}

## $1 = FROM
## $2 = TO
## $3 = IN
function installFor() {
  FROM=$1
  if [ "$2" == "" ]; then
    TO=$FROM
  else
    TO=$2
  fi

  if [ "$3" != "" ]; then
    mkdir -p ~/.$3
  fi

  echo "Linking $FROM to ~/.$TO..."
  rm ~/.$TO 2>/dev/null
  ln -s $PWD/$FROM ~/.$TO
}

function scriptFor() {
  if [ "$#" == 2 ]; then
    echo "Installing $1/$2..."
    . $1/$2
  else
    echo "Installing $1..."
    . $1/install.sh
  fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  installDotfiles
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    installDotfiles
  fi
fi
