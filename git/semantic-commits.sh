#!/bin/sh

# Register semantic commits git aliases
#
# $1 — git alias and semantic message prefix
# [$2] — (optional) custom semantic message prefix
function register_git_alias() {
  if ! git config --global --get-all alias.$1 &>/dev/null; then
    if [[ -z $2 ]]; then
      git config --global alias.$1 '!f() { [[ -z "$GIT_PREFIX" ]] || cd "$GIT_PREFIX" && if [ "$#" == 0 ]; then git commit -m "'$1': " --edit; elif [ "$#" == 2 ]; then git commit -m "'$1'(${1}): ${@:2}"; else git commit -m "'$1': ${@}"; fi }; f'
    else
      echo "Alias $1 to: '$2'"
      git config --global alias.$1 "!git $2"
    fi
  fi
}

echo 'Installing git aliases…'

semantic_aliases=('chore' 'docs' 'feat' 'fix' 'localize' 'perf' 'chore' 'refactor' 'style' 'test')

for semantic_alias in "${semantic_aliases[@]}"; do
  register_git_alias $semantic_alias
done

# git-extras chore/refactor compatibility (https://github.com/tj/git-extras)
# Docs: https://github.com/tj/git-extras/blob/master/Commands.md#git-featurerefactorbugchore
register_git_alias 'ch' 'chore'
register_git_alias 'rf' 'refactor'
register_git_alias 'c' 'chore'
register_git_alias 'd' 'docs'
register_git_alias 'f' 'feat'
register_git_alias 'p' 'perf'
register_git_alias 'x' 'fix'
register_git_alias 'l' 'localize'
register_git_alias 'r' 'refactor'
register_git_alias 's' 'style'
register_git_alias 't' 'test'

echo
echo 'Done! Now you can use semantic commits.'
echo 'See: https://github.com/fteem/git-semantic-commits for more information.'
