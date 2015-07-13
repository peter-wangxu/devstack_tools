# Environment Setup
* 2 ethernet cards attached to my devstack node
* eth0 is attached to `192.168.1.0/24`, and has IP `192.168.1.46`, traffic can reach external network via this port
* eth1 is attached to `192.168.2.0/24`, adn has IP `192.168.2.46`, it's in VLAN with `100`

# Devstack Configuration
* `Nova`, `Neutron`, `Manila`, `Cinder`, `Keystone`, `Glance` servies are enabled
* Cinder/Manila configurations are for VNX Cinder/Manila driver, you can remove/change according your favor.

Note:
before run stack.sh under devstack, Please set your `eth0` and `eth1` in [promisc mode] (https://en.wikipedia.org/wiki/Promiscuous_mode) if you want external communication via these 2 ports
and add `eth1` to OpenvSwitch bridge `br-eth1` or neutron agent will fail to startup.

    # Add eth1 into br-eth1 and set eth0 and eth1 to promisc mode
    sudo ovs-vsctl br-exists br-eth1 || sudo ovs-vsctl add-br br-eth1
    sudo ovs-vsctl --may-exist add-port br-eth1 eth1
    sudo ip link set dev eth1 promisc on
    sudo ip link set dev eth0 promisc on
    sudo ip addr flush eth1
    sudo ip link set dev eth1 up

