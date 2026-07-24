sudo iptables -A INPUT ! -i (your outside interface here) --dport 53 -j ACCEPT
