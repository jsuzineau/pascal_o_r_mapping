export interface_externe=(your outside interface here)
sudo iptables -A INPUT ! -i $interface_externe -p tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT ! -i $interface_externe -p udp --dport 53 -j ACCEPT
