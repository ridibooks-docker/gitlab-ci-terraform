#!/usr/bin/env bash

set -e

if [ -z "${TERRAFORM_VERSION}" ]; then
    TERRAFORM_VERSION=$(curl https://checkpoint-api.hashicorp.com/v1/check/terraform | sed -n 's|.*"current_version":"\([^"]*\)".*|\1|p')
fi

CONTAINER_ARCHITECTURE=linux_amd64
TERRAFORM_SHA256SUM=`curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS --silent | grep ${CONTAINER_ARCHITECTURE} | awk '{ print $1 }'`

echo "=> Building start with args"
echo "CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE}"
echo "TERRAFORM_VERSION=${TERRAFORM_VERSION}"
echo "TERRAFORM_SHA256SUM=${TERRAFORM_SHA256SUM}"

docker build \
  --build-arg CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE} \
  --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
  --build-arg TERRAFORM_SHA256SUM=${TERRAFORM_SHA256SUM} \
  -t ridibooks/gitlab-ci-terraform:${TERRAFORM_VERSION} .

docker tag ridibooks/gitlab-ci-terraform:${TERRAFORM_VERSION} ridibooks/gitlab-ci-terraform:latest
