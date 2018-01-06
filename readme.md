# dinbound
A combined dns service suite :
- `dingo`   https dns
- `unbound` dns service

## introduction
1. `dingo`    listens on port `54`, provides https dns
2. `unbound1` listens on port `53`, provides 53 port dns
3. `unbound2` listens on port `55`, provides non-53 port dns

## script usage
```bash
wget https://raw.githubusercontent.com/nanqinlang/dinbound/master/dinbound.sh
bash dinbound.sh
```

## according
https://sometimesnaive.org/article/linux/repo/dingo  
https://sometimesnaive.org/article/linux/repo/unbound