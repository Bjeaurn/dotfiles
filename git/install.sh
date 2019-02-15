#!/usr/bin/env bash

# Install global ignore file
mkdir -p ~/.config/git
cp $(dirname "$BASH_SOURCE")/ignore ~/.config/git/ignore

git config --global user.name "Bjorn 'Bjeaurn'"
git config --global color.ui true
git config --global push.default simple
git config --global pull.rebase true
git config --global remote.origin.prune true
git config --global commit.verbose true
git config --global diff.algorithm patience
git config --global diff.compactionHeuristic true

git config --global alias.amend "commit --amend"
git config --global alias.ci "commit -v"
git config --global alias.co checkout
git config --global alias.cpick cherry-pick
git config --global alias.empty "commit --allow-empty -m \"Trigger notification\""
git config --global alias.flush "clean -fd"
git config --global alias.flush-all "clean -fdx"
git config --global alias.mail "config user.email"
git config --global alias.master "!git stash && git co master && git pull && git prune-local && git stash pop"
git config --global alias.sts "status -s"
git config --global alias.prune-local "!git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -d"
git config --global alias.uncommit "reset HEAD^"
git config --global alias.wipe "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard"


# for presentations: see https://coderwall.com/p/ok-iyg/git-prev-next
git config --global alias.prev "checkout HEAD^1"
git config --global alias.next "!sh -c 'git log --reverse --pretty=%H master | awk \"/\$(git rev-parse HEAD)/{getline;print}\" | xargs git checkout'"

# merge and diff tools
git config --global merge.tool nano
git config --global merge.conflictstyle diff3
git config --global diff.tool nano
git config --global difftool.prompt false
git config --global alias.review "!f() { git difftool --tool=kdiff3 --dir-diff \$1..; }; f"


if [[ `uname -s` == MINGW* ]]; then
  # Windows
  git config --global core.autocrlf true
else
  # Unix
  # git config --global credential.helper cache
  git config --global credential.helper osxkeychain
fi
