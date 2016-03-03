#!/bin/bash
# [Steve] This is a local copy of our AWS instance user data. It runs on startup
#         whenever a new instance is provisioned. Updates to this are not
#         automatically synced to AWS.
# 1.) Install RVM and set ruby version
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable --ruby
# relogin as root to set ruby version
sudo su -
# set default rvm to ruby 2.2.0
rvm install ruby-2.2.0
rvm --default ruby-2.2.0
exit
# add ubuntu to rvm group so they can run rvm
sudo usermod -a -G rvm ubuntu
sudo usermod -a -G rvm root
# 2.) Install dependency managers and node
gem install bundler
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
