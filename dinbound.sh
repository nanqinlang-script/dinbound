#!/bin/bash

# download dir
directory(){
	[[ ! -d /home/dinbound ]] && mkdir -p /home/dinbound
	cd /home/dinbound
}

download(){
	wget https://raw.githubusercontent.com/nanqinlang/dinbound/master/dingo-linux-amd64
	wget https://raw.githubusercontent.com/nanqinlang/dinbound/master/unbound1.tar.gz && tar -zxf unbound1.tar.gz
	wget https://raw.githubusercontent.com/nanqinlang/dinbound/master/unbound2.tar.gz && tar -zxf unbound2.tar.gz
}

# port 53 + 55
unbound(){
	cp /home/dinbound/unbound1 /home/unbound1 && chmod -R 7777 /home/unbound1 && /home/unbound1/sbin/unbound
	cp /home/dinbound/unbound2 /home/unbound2 && chmod -R 7777 /home/unbound2 && /home/unbound2/sbin/unbound
}

# port 54
dingo(){
	mkdir /home/dingo
	cp /home/dinbound/dingo-linux-amd64 /home/dingo/dingo-linux-amd64
	chmod -R 7777 /home/dingo
	cd /home/dingo && nohup ./dingo-linux-amd64 -port=54 -bind=127.0.0.1 -gdns:auto &
}


# main:
directory
download
unbound
dingo
#rm -rf /home/dinbound

# change resolv.conf
mv /etc/resolv.conf /etc/resolv.conf.bak
echo "nameserver 127.0.0.1" > /etc/resolv.conf