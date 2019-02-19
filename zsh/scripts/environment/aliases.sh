# brew install bat
# brew install ctags

alias cd..='cd ..'
alias h='cd ~/Development/'
alias d='cd ~/Development/'
alias gbda='git prune-merged'
alias gst='git status'
alias gs='gitsearch'

# So we can type `git add *Test*` instead of `git add "*Test*"`
# alias git="noglob git"


# MacOS pre-installs a bad version of ctags so we substitute our own.
if [[ "$(uname -s)" == "Darwin" ]]
then
  alias ctags="`brew --prefix`/bin/ctags"
fi