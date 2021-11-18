#!/bin/bash

# enable color support and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    export COLOR_AUTO=' --color=auto'
fi

###
# Include local customizations
if [ -f ~/.bash_alias_local ]
then
	# shellcheck source=/dev/null
	. ~/.bash_alias_local
fi

if [ -d ~/.bash_aliases_local ]; then
	for f in ~/.bash_aliases_local/*
	do
		if [ -f "$f" ]; then
			. "$f"
		fi
	done
fi
