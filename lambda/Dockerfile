FROM registry.gitlab.com/guardianproject-ops/docker-python-node:python3.7-nodejs12

# the terraform-aws-lambda module will mount the lambda sources into this directory
# and expect it to be the CWD when calling `docker run`
WORKDIR /var/task
