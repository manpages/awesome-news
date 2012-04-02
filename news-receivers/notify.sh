export DISPLAY=:0
while true; do
	read var;
	tex=$(echo "${var##*\" \"}" | sed 's/"$//')
	sum=$(echo "${var%%\" \"*}" | sed 's/^"//')
	echo "$sum :: $tex"
	notify-send "$sum" "$tex";
done
