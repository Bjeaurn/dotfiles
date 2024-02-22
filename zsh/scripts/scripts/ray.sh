#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create Image from Code
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./images/ray-so.png
# @raycast.argument1 { "type": "text", "placeholder": "Title", "optional": true }

# Documentation:
# @raycast.description Create beautiful images of your code with https://ray.so
# @raycast.author Thomas Paul Mann
# @raycast.authorURL https://github.com/thomaspaulmann

# Customization:
# Set colors. Available options: candy, breeze, midnight or sunset
COLORS="sunset" 
# Toggle background. Available options: true or false
BACKGROUND="true"
# Toggle dark mode. Available options: true or false
DARK_MODE="true"
# Set padding. Available options: 16, 32, 64 or 128
PADDING="16"
# Set language. Available options: shell, cpp (C/C++), csharp, clojure, coffeescript, crystal, css, d, dart, diff, dockerfile, elm, erlang, fortran, gherkin,
# go, groovy, haskell, xml, java, javascript, json, jsx, julia, kotlin, latex, lisp, lua, markdown, mathematica, octave, nginx, objectivec, ocaml (F#), perl, php,
# powershell, python, r, ruby, rust, scala, smalltalk, sql, swift, typescript, (for Tsx, use jsx), twig, verilog, vhdl, xquery, yaml
LANGUAGE="auto"

# Main:

if [[ -z "$1" ]]
then 
  TITLE="Untitled-1"
else
  TITLE=$(php -r "echo urlencode(\"$1\");")
fi

CODE=$(pbpaste | base64)
# Urlencode any + symbols in the base64 encoded string
CODE=${CODE//+/%2B}


open "https://carbon.now.sh/?bg=rgba%2874%2C144%2C226%2C1%29&t=a11y-dark&wt=none&l=auto&ds=false&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=16px&ph=16px&ln=false&fl=1&fm=Fira+Code&fs=14px&lh=152%25&si=false&es=2x&wm=false&code=$(pbpaste)"
open "https://ray.so/?colors=$COLORS&background=$BACKGROUND&darkMode=$DARK_MODE&padding=$PADDING&title=$TITLE&code=$CODE&language=$LANGUAGE"
