mkdir /tmp/i3lock
PICTURE=/tmp/i3lock/i3lock.png

scrot $PICTURE
convert $PICTURE \
	-blur 10x5 \
	-sample 5% \
	-noise 0.1 \
	+noise Uniform \
	-level 0,150% \
	$PICTURE

i3lock -i $PICTURE -e -f

