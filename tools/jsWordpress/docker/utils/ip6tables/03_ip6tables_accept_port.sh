sudo ip6tables -A INPUT -p tcp --dport $1 -j ACCEPT
