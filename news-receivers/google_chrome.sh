export DISPLAY=:0
while true; do
	read var;
	echo "Opening $var"
	google-chrome $var &
done
