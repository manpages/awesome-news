#!/bin/bash
# We might want to check deps somehow, though it isn't obligatory
# Leave that to the package manager.
echo "Please make sure these are installed: git, erlang, gcc, make, autoconf"
echo -n "Press enter to continue..."
read

cd ..
mkdir awesome-news-folder
mv -uvt ./awesome-news-folder ./awesome-news
cd awesome-news-folder

echo "YAWS! incoming!"
	git clone git://github.com/klacke/yaws.git
	cd yaws
	autoconf; ./configure; make; make local_install
	cd ..
	curl -s http://memoricide.very.lv/yaws.conf | sed '/^\s*appmods/s/^/#/; 143 c\    docroot = '"$PWD"'/http' > yaws.conf
	mkdir logs
	mkdir http

echo "Discovery channel"
	git clone git://github.com/manpages/resource_discovery.git 
	cd resource_discovery
	erl -make
	cd ..

echo "Awesome news"
	git clone git://github.com/manpages/awesome-news.git
	cd awesome-news
	erl -make
	cd ..
	cp -uvt ./http/ ./awesome-news/index.yaws

echo "Making sources"
	cd awesome-news
	erl -make
	cd ..

echo "Packaging sender"
	erl -pa awesome-news/ebin/ fission/ebin/ resource_discovery/ebin/ yaws/ebin/ \
	-eval 'systools:make_script("an_sender", [local])' -run init stop \
	-noshell

id=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 6)
id1=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 6)
defhost=$(curl -s icanhazip.com)

echo "Configuring hostname..."
	echo -n "Enter desired receiver hostname: [$defhost] "
	read host
	[[ -z "$host" ]] && host=$defhost

defname="$id@$host"
defname1="$id1@$host"

echo -n "Enter desired sender node address: [$defname1] "
	read name1
	[[ -z "$name1" ]] && name1=$defname1

echo -n "Enter desired bootstrap node: [$name1] "
	read bootstrap
	[[ -z "$bootstrap" ]] && bootstrap=$name1

defcookie=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
echo -n "Enter cloud password: [$defcookie] "
	read cookie
	[[ -z "$cookie" ]] && cookie=$defcookie

echo -n "Sender config: "
echo "erl -setcookie $cookie -name $name1 -contact_node $bootstrap -boot an_sender -noshell" | tee sender.sh

echo '#!/bin/bash' > receiver.sh
echo 'receiver=$1;' >> receiver.sh
echo '[[ -z $receiver ]] && receiver='generic_receiver';' >> receiver.sh
echo "erl -setcookie $cookie -name \$receiver@$host -contact_node $name1 \\" >> receiver.sh
echo '	-eval "application:start(resource_discovery)" -eval "an_receiver:start(an_$receiver)" \' >> receiver.sh
echo '	-pa resource_discovery/ebin/ awesome-news/ebin/ -noshell' >> receiver.sh
echo "Receiver is configured."
