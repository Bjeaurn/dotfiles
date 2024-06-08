# brew install bat
# brew install ctags

alias cd..='cd ..'
alias ll="ls -l"
alias h="cd $DEFAULT_DEV"
alias d="cd $DEFAULT_DEV"
alias gbda='git prune-merged'
alias gst='git status'
alias gs='gitsearch'
alias gcm='git checkout master || git checkout main'

alias video2gif='function video2gif(){ ffmpeg -i "$1" "${1%.*}.gif" && gifsicle -O3 "${1%.*}.gif" -o "${1%.*}.gif" && osascript -e "display notification \"${1%.*}.gif successfully converted and saved\" with title \"MOV2GIF SUCCESS!\""};video2gif'

### Environment specific aliases
alias ci='echo "No CI set for this environment."'
alias dotfiles="cd $DEFAULT_DEV/dotfiles"

# So we can type `git add *Test*` instead of `git add "*Test*"`
alias git="noglob git"

# MacOS pre-installs a bad version of ctags so we substitute our own.
if [[ "$(uname -s)" == "Darwin" ]]; then
  alias ctags="$(brew --prefix)/bin/ctags"
fi
