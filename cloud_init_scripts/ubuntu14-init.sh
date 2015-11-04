#!/bin/bash 
echo "Creating user stack..."
useradd -m -G sudo -s /bin/bash stack
# Set password as welcome
echo 'stack:welcome' | chpasswd
cat >>/etc/sudoers <<'EOF'

stack   ALL=(ALL) NOPASSWD:ALL
Defaults:stack !requiretty
EOF

cat >>/etc/resolvconf/resolv.conf.d/base <<'EOF'
nameserver 10.245.177.15
nameserver 10.245.177.16
EOF

resolvconf -u

apt-get -qy install git vim 
apt-get -qy install linux-image-extra-$(uname -r)
chmod +x /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
chmod -x /etc/ssh/sshd_config
service ssh restart
echo "Finished cloud-init."

