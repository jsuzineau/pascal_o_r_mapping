sudo ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo ip6tables -A OUTPUT -p tcp --dport 53 -j ACCEPT