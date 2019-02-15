#!/usr/bin/env bash

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
echo "Updating Homebrew"
brew update

# Install all our dependencies with bundle (See Brewfile)
echo "Installing Brewfile"
brew tap homebrew/bundle
brew bundle