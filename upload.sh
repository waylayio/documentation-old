#!/bin/bash
set -e

echo "copying site folder contents to s3://docs.waylay.io"

# http://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html
aws --color=auto \
  --recursive \
  --exclude="node_modules/*" \
  --exclude=".DS_Store" \
  --exclude=".git" \
  --exclude="less/*" \
  --region "us-east-1" \
  s3 cp site s3://docs.waylay.io/

echo "invalidating cache"

# this is still a beta feature
aws configure set preview.cloudfront true
aws cloudfront create-invalidation --distribution-id E1ZHXE4FBEJAOE --paths '/*'
