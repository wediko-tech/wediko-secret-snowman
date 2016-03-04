#!/bin/bash
# [Steve] This is a local copy of our AWS instance user data. It runs on startup
#         whenever a new instance is provisioned. Updates to this are not
#         automatically synced to AWS.
# 1.) Install rbenv and set ruby version
sudo apt-get install git gcc make
git clone https://github.com/rbenv/rbenv.git /home/ubuntu/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc
bash -l
echo "$(rbenv init -)" >> /home/ubuntu/.bashrc
git clone https://github.com/garnieretienne/rvm-download.git /home/ubuntu/.rbenv/plugins/rvm-download
# reset bash
bash -l
rbenv download 2.2.0
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
exit
exit
