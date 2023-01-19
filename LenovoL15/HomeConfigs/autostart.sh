picom &
nitrogen --restore &

alacritty &

#amixer -c 1 set 'Beep' 1
amixer -c 1 set 'Master' 31
amixer -c 1 set 'Headphone' 39
#amixer -c 1 set 'Mic Boost' 1
#amixer -c 1 set 'Internal Mic Boost' 1

sudo setcpugovernor normal

sleep 2

/files/Code/bin/tempwarning

exit 0
