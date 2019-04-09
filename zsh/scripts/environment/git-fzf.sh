function select_branch() {
  local branch
  
  zle -M "Select a branch to switch to:\n"

  branch=$(git branch -a --list --format "%(refname:lstrip=2)" | FZF_DEFAULT_OPTS="--height 30% $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf)

  if [[ ! -z "$branch" ]];
  then
    # Note to future self: the syntax ${variable/<regex>/<replacement>} is just frikkin awesome
    git checkout ${branch/origin\//}
  fi

  echo "\n\n"
  zle reset-prompt
}
