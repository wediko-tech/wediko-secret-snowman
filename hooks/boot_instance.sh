#!/bin/bash
# [Steve] This is a local copy of our AWS instance user data. It runs on startup
#         whenever a new instance is provisioned. Updates to this are not
#         automatically synced to AWS.
# 1.) Install rbenv and set ruby version
sudo apt-get -y install git gcc make zlib1g-dev libsqlite3-dev
git clone https://github.com/rbenv/rbenv.git /home/ubuntu/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc
echo "$(rbenv init -)" >> /home/ubuntu/.bashrc
git clone https://github.com/garnieretienne/rvm-download.git /home/ubuntu/.rbenv/plugins/rvm-download
rbenv download 2.2.0
# 2.) Install dependency managers and node
sudo apt-get -y install bundler
sudo apt-get -y install nodejs

# 3.) Install the AWS CLI to allow automated deploys
sudo apt-get update
sudo apt-get -y install python-pip
sudo apt-get -y install ruby2.0
sudo pip install awscli
cd /home/ubuntu
aws s3 cp s3://aws-codedeploy-us-west-2/latest/install . --region us-west-2
chmod 755 install
sudo ./install auto
sudo service codedeploy-agent start
