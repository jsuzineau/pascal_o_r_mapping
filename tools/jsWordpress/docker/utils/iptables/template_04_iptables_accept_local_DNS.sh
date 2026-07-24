sudo iptables -A INPUT ! -i (your outside interface here) tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT ! -i (your outside interface here) udp --dport 53 -j ACCEPT
