#!/bin/bash

# download dir
directory(){
	[[ ! -d /home/dinbound ]] && mkdir -p /home/dinbound
}

dingo-download(){
	cd /home/dinbound
	wget https://raw.githubusercontent.com/nanqinlang/dinbound/master/dingo-linux-amd64
}

# port 54
dingo-start(){
	mkdir /home/dingo
	cd /home/dinbound
	mv dingo-linux-amd64 /home/dingo/dingo-linux-amd64
	cd /home/dingo
	chmod +x dingo-linux-amd64
	nohup ./dingo-linux-amd64 -port=54 -bind=127.0.0.1 -gdns:auto &
}


unbound-compile(){
	cd /home/dinbound
	wget https://raw.githubusercontent.com/nanqinlang-script/unbound/master/unbound-1.6.7.tar.gz && tar -zxf unbound-1.6.7.tar.gz
	cd unbound-1.6.7
	apt-get update && apt-get install -y build-essential && apt-get build-dep -y unbound

	./configure --prefix=/home/unbound1 --sysconfdir=/home/unbound1/etc --with-pidfile=/home/unbound1/pid/unbound.pid --with-libevent --disable-rpath
	make && make install

	make clean

	./configure --prefix=/home/unbound2 --sysconfdir=/home/unbound2/etc --with-pidfile=/home/unbound2/pid/unbound.pid --with-libevent --disable-rpath
	make && make install
}

unbound-config(){
	cd /home/dinbound
	wget https://raw.githubusercontent.com/nanqinlang-script/unbound/master/unbound1.conf
	wget https://raw.githubusercontent.com/nanqinlang-script/unbound/master/unbound2.conf
	mv -f unbound1.conf /home/unbound1/etc/unbound/unbound.conf
	mv -f unbound2.conf /home/unbound2/etc/unbound/unbound.conf
}

unbound-start(){
	# port 53
	chmod -R 0777 /home/unbound1 && /home/unbound1/sbin/unbound
	# port 55
	chmod -R 0777 /home/unbound2 && /home/unbound2/sbin/unbound
}



directory
dingo-download
dingo-start
unbound-compile
unbound-config
unbound-start
rm -rf /home/dinbound

# change resolv.conf
mv /etc/resolv.conf /etc/resolv.conf.bak
echo "nameserver 127.0.0.1" > /etc/resolv.conf