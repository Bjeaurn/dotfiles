# # Assign the current VI mode to the env variable VIMODE
# function zle-keymap-select zle-line-init zle-line-finish {
#   case $KEYMAP in
#     vicmd)
#       export VIMODE='n'
#       ;;
#     viins|main)
#       export VIMODE='i'
#       ;;
#   esac
#
#   zle reset-prompt
#   zle -R
# }
# zle -N zle-line-init
# zle -N zle-line-finish
# zle -N zle-keymap-select

export VIMODE='i'
MODE_INDICATOR=""

function setenv_prompt_injection() {
  [[ -e ~/.setEnv/prompt ]] && cat ~/.setEnv/prompt
}

function ret_status() {
  local RET_STATUS=""
  [[ $1 -ne 0 ]] && RET_STATUS="×"
  echo $RET_STATUS
}

function root_and_jobs() {
  local SYMS=""
  [[ $UID -eq 0 ]] && SYMS+="⚡ "
  [[ $(jobs -l | wc -l) -gt 0 ]] && SYMS="λ"
  echo $SYMS
}

function working_directory() {
  echo "%~"
}

function is_inside_git() {
  [[ -n "$GIT_STATUS_FULL" ]]
}

function is_git_dirty() {
  # This regex looks like a smiley but it means there must be no space on the second char of the line
  echo $GIT_STATUS | grep "^.[^ ]" > /dev/null 2>&1
  [[ "$?" -eq 0 ]] && echo $1 || echo $2
}

function git_branch() {
  local BRANCH=$(git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
  [[ -n $BRANCH ]] && echo $BRANCH || echo '?'
}

function git_local() {
  local INFO=""

  # Staged changes
  echo $GIT_STATUS | grep "^D" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="D"
  echo $GIT_STATUS | grep "^A" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="A"
  echo $GIT_STATUS | grep "^M" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="M"
  echo $GIT_STATUS | grep "^R" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="R"

  # Assumed flag
  local GIT_ASSUMED=$(git ls-files -v | grep ^h 2> /dev/null)
  [[ -n "$GIT_ASSUMED" ]] && INFO+="(ASSUMED)"

  echo $INFO
}

function git_remote() {
  local INFO=""

  # Ahead, behind
  echo $GIT_STATUS_FULL | grep "ahead" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="↑$(echo "$GIT_STATUS_FULL" | sed 's/.*ahead \([0-9]*\).*/\1/; 1q')"
  echo $GIT_STATUS_FULL | grep "behind" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && INFO+="↓$(echo "$GIT_STATUS_FULL" | sed 's/.*behind \([0-9]*\).*/\1/; 1q')"

  # Stashes flag
  local GIT_STASHED=$(git stash list 2> /dev/null)
  [[ "${#GIT_STASHED}" -gt 0 ]] && INFO+="Σ$(echo "$GIT_STASHED" | wc -l | sed 's/^[ \t]*//')" # strip tabs

  echo $INFO
}

function git_warnings() {
  local WARNINGS=""

  # Diverged
  echo $GIT_STATUS_FULL | grep "ahead" | grep "behind" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && WARNINGS+="Δ"

  # Merging
  echo $GIT_STATUS_FULL | grep "Unmerged paths" > /dev/null 2>&1
  [[ "$?" -eq "0" ]] && WARNINGS+="🔀 "

  # Warning for no email setting
  git config user.email | grep @ > /dev/null 2>&1
  [[ "$?" -ne 0 ]] && WARNINGS+="!!! NO EMAIL SET !!!"

  echo $WARNINGS
}

function build_prompt() {
  # Capturing the exit code must happen first
  local EXIT=$?

  # if [ "$VIMODE" == "n" ]
  # then
  #   local RED="%{$bg_bold[yellow]$fg_bold[black]%}"
  #   local GREEN="%{$bg_bold[yellow]$fg_bold[black]%}"
  #   local YELLOW="%{$bg_bold[yellow]$fg_bold[black]%}"
  #   local CYAN="%{$bg_bold[yellow]$fg_bold[black]%}"
  #   local MAGENTA="%{$bg_bold[yellow]$fg_bold[black]%}"
  #   local WHITE="%{$bg_bold[yellow]$fg_bold[black]%}"
  # else
    local RED="%{$fg_bold[red]%}"
    local GREEN="%{$fg_bold[green]%}"
    local YELLOW="%{$fg_bold[yellow]%}"
    local CYAN="%{$fg_bold[cyan]%}"
    local MAGENTA="%{$fg_bold[magenta]%}"
    local WHITE="%{$fg_bold[white]%}"
  # fi

  local RAW_SEP="❯"
  local SEPCOLOR=$CYAN
  local SEP="$SEPCOLOR$RAW_SEP"
  local P=""

  P+="$WHITE┌ "
  P+="$SEP $GREEN$(working_directory)"

  GIT_STATUS_FULL=$(git status -sb 2> /dev/null)
  local GIT_WARNINGS=""
  if is_inside_git
  then
    GIT_STATUS=$(git status --porcelain 2> /dev/null)

    P+=" $SEP $YELLOW$(git_branch)"

    local REMOTE=$(git_remote)
    local LOCAL=$(git_local)
    [[ -n "$REMOTE" ]] && P+=" $SEP $YELLOW$REMOTE"
    [[ -n "$LOCAL" ]] && P+=" $SEP $YELLOW$LOCAL"

    GIT_WARNINGS=$(git_warnings)
  fi

  P+=" $SEP"

  P+="\n"
  P+="$WHITE└ "


  local SYMS=$(root_and_jobs)
  local RET_STATUS=$(ret_status $EXIT)
  local INJECTION=$(setenv_prompt_injection)
  [[ -n "$RET_STATUS$SYMS$GIT_WARNINGS$INJECTION" ]] && P+="$SEP "
  [[ -n "$SYMS" ]] && P+="$YELLOW$SYMS"
  [[ -n "$RET_STATUS" ]] && P+="$RED$RET_STATUS"
  [[ -n "$GIT_WARNINGS" ]] && P+="$RED$GIT_WARNINGS"
  [[ -n "$INJECTION" ]] && P+="$INJECTION"
  [[ -n "$RET_STATUS$SYMS$GIT_WARNINGS$INJECTION" ]] && P+=" "

  P+="$(is_git_dirty $RED $SEPCOLOR)$RAW_SEP"

  P+="%{$reset_color%} "

  echo $P
}

PROMPT=$'$(build_prompt)'
