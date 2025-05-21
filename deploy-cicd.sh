#!/bin/bash

# Paramètres
REPO="JordanB001/aws-test"
BRANCH="master"
TOKEN="ghp_xxxxxxxx"
BUCKET="awsdemo.jordanb.ovh"

# 1. Crée les rôles IAM
aws cloudformation deploy \
  --template-file cfn-iam-roles.yaml \
  --stack-name awsdemo-iam-roles \
  --capabilities CAPABILITY_NAMED_IAM

# 2. Récupère les ARNs générés
CB_ROLE=$(aws cloudformation describe-stacks \
  --stack-name awsdemo-iam-roles \
  --query "Stacks[0].Outputs[?OutputKey=='CodeBuildRoleArn'].OutputValue" --output text)

CP_ROLE=$(aws cloudformation describe-stacks \
  --stack-name awsdemo-iam-roles \
  --query "Stacks[0].Outputs[?OutputKey=='CodePipelineRoleArn'].OutputValue" --output text)

# 3. Crée la pipeline CI/CD
aws cloudformation deploy \
  --template-file cfn-ci-cd.yml \
  --stack-name awsdemo-front-cicd \
  --parameter-overrides \
    GitHubRepo=$REPO \
    GitHubBranch=$BRANCH \
    GitHubToken=$TOKEN \
    S3BucketName=$BUCKET \
    CodeBuildRoleArn=$CB_ROLE \
    CodePipelineRoleArn=$CP_ROLE \
  --capabilities CAPABILITY_NAMED_IAM
