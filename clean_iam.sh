#!/bin/bash
set -e

REGION="eu-north-1"

echo "=== [1] Cleaning up IAM resources ==="
aws iam detach-group-policy --group-name WebAdmins --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess || true
aws iam detach-group-policy --group-name DBAdmins --policy-arn arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess || true

aws iam remove-user-from-group --user-name TestWebUser --group-name WebAdmins || true
aws iam remove-user-from-group --user-name TestDBUser --group-name DBAdmins || true

aws iam delete-user --user-name TestWebUser || true
aws iam delete-user --user-name TestDBUser || true

aws iam delete-group --group-name WebAdmins || true
aws iam delete-group --group-name DBAdmins || true

echo "=== [2] Cleaning up VPC and subnets ==="
VPC_ID=$(aws ec2 describe-vpcs --region $REGION --filters "Name=tag:Name,Values=IAMProjectVPC" --query 'Vpcs[0].VpcId' --output text)
if [ "$VPC_ID" != "None" ]; then
  SUBNET_IDS=$(aws ec2 describe-subnets --region $REGION --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' --output text)
  for SUBNET_ID in $SUBNET_IDS; do
    aws ec2 delete-subnet --region $REGION --subnet-id "$SUBNET_ID" || true
  done
  aws ec2 delete-vpc --region $REGION --vpc-id "$VPC_ID" || true
fi

echo "✅ Cleanup complete for region $REGION."
