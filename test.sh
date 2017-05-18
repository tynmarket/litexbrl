#!/bin/sh
set -x

bundle exec rspec -r rspec_junit_formatter --format RspecJunitFormatter -o $CIRCLE_TEST_REPORTS/rspec/junit.xml
RSPEC_RESULT=$?

AWS_DEFAULT_REGION=ap-northeast-1 aws ec2 revoke-security-group-ingress --group-id sg-f8da2d9e --protocol tcp --port 80 --cidr `curl -s ifconfig.io`/32
AWS_RESULT=$?

if [ $RSPEC_RESULT -ne 0 ]; then
  exit $RSPEC_RESULT
elif [ $AWS_RESULT -ne 0 ]; then
  exit $AWS_RESULT
else
  exit
fi
