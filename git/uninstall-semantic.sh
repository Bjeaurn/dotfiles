#!/bin/sh
function unregister_alias() {
    git config --global --unset alias.$1
}

semantic_aliases=('chore' 'docs' 'feat' 'fix' 'localize' 'perf' 'chore' 'refactor' 'style' 'test')
for semantic_alias in "${semantic_aliases[@]}"; do
    unregister_alias $semantic_alias
done

# git-extras chore/refactor compatibility (https://github.com/tj/git-extras)
# Docs: https://github.com/tj/git-extras/blob/master/Commands.md#git-featurerefactorbugchore
unregister_alias 'ch'
unregister_alias 'rf'
unregister_alias 'c'
unregister_alias 'd'
unregister_alias 'f'
unregister_alias 'p'
unregister_alias 'x'
unregister_alias 'l'
unregister_alias 'r'
unregister_alias 's'
unregister_alias 't'
