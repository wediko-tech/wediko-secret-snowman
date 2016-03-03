#!/bin/bash
# [Steve] This is a local copy of our AWS instance user data. It runs on startup
#         whenever a new instance is provisioned. Updates to this are not
#         automatically synced to AWS.
# 1.) Install RVM and set ruby version
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable --ruby
# set default rvm to ruby 2.2.0
rvmsudo rvm install ruby-2.2.0
# add ubuntu to rvm group so they can run rvm
sudo usermod -a -G rvm ubuntu
# 2.) Install dependency managers and node
sudo apt-get install bundler
sudo apt-get install nodejs

# 3.) Install the AWS CLI to allow automated deploys
sudo apt-get update
sudo apt-get install python-pip
sudo apt-get install ruby2.0
sudo pip install awscli
cd /home/ubuntu
aws s3 cp s3://aws-codedeploy-us-west-2/latest/install . --region us-west-2
chmod 755 install
sudo ./install auto
sudo service codedeploy-agent start

# 4.) Change sudoers file to persist RVM config in sudo
sudo bash -c "cat \"/etc/sudoers\" > /etc/sudoers.bak"
sudo bash -c "echo \"Defaults env_keep +=\\\"rvm_bin_path GEM_HOME IRBRC MY_RUBY_HOME rvm_path rvm_prefix rvm_version GEM_PATH rvmsudo_secure_path RUBY_VERSION rvm_ruby_string rvm_delete_flag\\\"\" >> /etc/sudoers"
# new_sudoers=`sudo bash -c "sed \"s/^Defaults.\{1,\}secure_path=/# Defaults secure_path=/\" < /etc/sudoers"`
# sudo bash -c "cat \"/etc/sudoers\" > /etc/sudoers.bak"
# sudo bash -c "echo \"$new_sudoers\" > /etc/sudoers"
