export interface_externe=(your outside interface here) 
sudo ip6tables -A DOCKER-USER -i $interface_externe -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A DOCKER-USER -i $interface_externe -j DROP
