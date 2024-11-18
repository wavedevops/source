# export key pare local to aws
aws ec2 import-key-pair --key-name "allow_all" --public-key-material fileb://~/.ssh/allow_all.pub