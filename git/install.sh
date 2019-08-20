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
git config --global alias.uncommit "reset --soft HEAD^"
git config --global alias.wipe "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard"
git config --global alias.prune-merged "!git branch --merged master | grep -v \"\* master\" | xargs -n 1 git branch -d"

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


# Register semantic commits git aliases
#
# $1 — git alias and semantic message prefix
# [$2] — (optional) custom semantic message prefix
function make_git_alias {
  if ! git config --global --get-all alias.$1 &>/dev/null; then
    git config --global alias.$1  '!f() { [[ -z "$GIT_PREFIX" ]] || cd "$GIT_PREFIX" && if [[ -z $1 ]] && [[-z $2]]; then git commit -m "'$1' " -e; else git commit -$3m "'$1'($1): $2"; fi }; f'
    echo 'Alias installed ' $1
  else
    echo $1 : 'alias already present, remove it from ~/.gitconfig file first'
  fi
}
# Register aliases
echo 'Installing git aliases'

  semantic_aliases=( 'feat' 'fix' 'style' 'cleanup' 'refactor' 'perf' 'test' 'chore' 'tracking' 'docs' )

  for semantic_alias in "${semantic_aliases[@]}"; do
    make_git_alias $semantic_alias
  done