#!/bin/bash 
echo "Creating user stack..."
useradd -m -G adm -s /bin/bash stack
echo 'stack:welcome' | chpasswd
cat >>/etc/sudoers <<'EOF'

stack   ALL=(ALL) NOPASSWD:ALL
Defaults:stack !requiretty
EOF

cat >>/etc/resolv.conf <<'EOF'
nameserver 10.245.177.15
nameserver 10.245.177.16
EOF

#resolvconf -u
yum -y update

# enable EPEL repo on CentOS7/RHEL7
yum install epel-release

yum -y install git vim
yum -y install python-pip python-devel openssl-devel wget curl
yum -y install python-tox device-mapper-multipath
# install packages for development
yum groupinstall "Development Tools"


chmod +x /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
chmod -x /etc/ssh/sshd_config
service sshd restart
echo "Finished cloud-init."

