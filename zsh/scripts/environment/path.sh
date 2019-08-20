function addToPath() {
    [[ $1 ]] && [[ ":$PATH:" != *"$1"* ]] && export PATH="$PATH:$1"
}