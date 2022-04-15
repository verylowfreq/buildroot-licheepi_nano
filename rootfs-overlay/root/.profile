#!/bin/sh

export HISTFILE=
export HISTFILESIZE=0

echo Set LANG=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

echo Set JP106 keyboard keymap with disabling CapsLock
#loadkeys jp106
zcat /usr/share/keymaps/i386/qwerty/jp106.map.gz | \
        sed -e's/Caps_Lock/Control/' | loadkeys

export PS1="[\w]\\$ "

IS_TERMINAL_OVER_SERIAL=`tty | grep "/dev/ttyS"`

if [ "$IS_TERMINAL_OVER_SERIAL" != "" ]; then
	export PS1="[\u@\h \w]\\$ "
        echo "Session over UART"

elif [ "$TERM" != "yaft-256color" ]; then
        echo Execute Vim in yaft...
        # sleep 1
        # /usr/bin/yaft
        /usr/bin/yaft vim /root/note.txt
        /usr/bin/yaft_wall /root/space_480x272.png
fi

