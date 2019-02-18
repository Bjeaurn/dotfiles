# brew install bat
# brew install ctags

alias cd..='cd ..'

alias gst='git status'

# So we can type `git add *Test*` instead of `git add "*Test*"`
# alias git="noglob git"


# MacOS pre-installs a bad version of ctags so we substitute our own.
if [[ "$(uname -s)" == "Darwin" ]]
then
  alias ctags="`brew --prefix`/bin/ctags"
fi
