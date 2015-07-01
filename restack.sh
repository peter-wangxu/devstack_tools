#!/usr/bin/env bash
#################################################################
#              Fully reinstall an existing devstack             #
# Before run this script, you need to clone a devstack from     #
# http://github.com/openstack-dev/devstack.git in /home/stack/  #
# , switch to branch you desire, a local.conf is required       #
# in /home/stack/devstack/ as well                              #
#################################################################

cd /home/stack/devstack
./unstack.sh
sed -i 's|GIT_BASE:-git://git.openstack.org|GIT_BASE:-http://git.openstack.org|' stackrc
# Hold current change in devstack and restore after pull completed
git stash
git pull
git stash pop
# Remove all pip-based python package
pip list | awk '$1 !~ /pip/ {print $1}'| xargs sudo pip  uninstall -y
sudo rm -rf /opt/stack
# Kill all python processes
for x in $(ps -ef | awk '/python/ {print $2}');do
    sudo kill -KILL $x
done
# Update all deb-based packages
sudo apt-get update && sudo apt-get upgrade -y
#sync && sudo reboot -f
# After rebooted, run ./stack
# Install coverage which is not installed by devstack
sudo pip install setuptools
sudo rm -rf /tmp/coveragepy
git clone https://github.com/nedbat/coveragepy.git /tmp/coveragepy
cd /tmp/coveragepy/
sudo python setup.py install
sudo rm -rf /tmp/coveragepy

# Remove some local.conf cinder.conf nova.conf etc in user's home directory
# to avoid some incidental installation failure
cd ~
rm -fv local.conf
rm -fv {cinder,nova,swift,glance,neutron,keystone,manila}.conf
find  /etc/apache2/ -name '*horizon*' | sudo xargs rm -f

cd /home/stack/devstack
if git status|grep "On branch master">/dev/null; then
        sudo pip install MySQL-python
elif git status|grep "On branch stable/kilo">/dev/null; then
        sudo pip install MySQL-python
else
        sudo pip install MySQL-python==1.2.3
fi
sed -i 's|GIT_BASE:-git://git.openstack.org|GIT_BASE:-http://git.openstack.org|' stackrc
./stack.sh

