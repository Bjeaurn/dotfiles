function addToPath() {
    [[ $1 ]] && [[ ":$PATH:" != *"$1"* ]] && export PATH="$PATH:$1"
}

function isHetWarm() {
    local TEMP=$(bc <<<"scale=3; $(ioreg -r -n AppleSmartBattery | grep Temperature | cut -c23-)/100")
    local THROTTLE=$(bc <<<"$(pmset -g therm | grep Speed_Limit | cut -d= -f2)")
    echo "Battery temperature: $TEMP"
    echo "CPU Throttled to: $THROTTLE%"
    if [[ $TEMP < 30 && $THROTTLE > 79 ]]; then
        echo "Nah, het is niet zo heel erg warm"
    elif [[ $TEMP < 32 ]]; then
        echo "MWah, een beetje verkoeling kan geen kwaad hoor"
    elif [[ $TEMP > 32 ]]; then
        echo "Holy hell dude, submerge me in water now!"
    elif [[ $THROTTLE < 80 ]]; then
        echo "Het is okay, maar wil je stoppen met whatever je die CPU zo voor mishandelt?"
    fi
}
