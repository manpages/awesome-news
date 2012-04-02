export DISPLAY=:0
while true; do
	read var;
	echo "Opening $var"
	firefox $var &
done
