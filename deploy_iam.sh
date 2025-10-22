#!/bin/bash
set -e  # stop on first error

# === Configuration ===
REGION="eu-north-1"
VPC_NAME="IAMProjectVPC"
WEB_SUBNET_NAME="WebSubnet"
DB_SUBNET_NAME="DBSubnet"
CIDR_VPC="10.0.0.0/16"
CIDR_WEB="10.0.1.0/24"
CIDR_DB="10.0.2.0/24"

echo "=== [1] Creating VPC in $REGION ==="
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $CIDR_VPC \
  --region $REGION \
  --query 'Vpc.VpcId' \
  --output text)

if [ -z "$VPC_ID" ]; then
  echo "❌ Failed to create VPC."
  exit 1
fi

echo "✅ VPC created: $VPC_ID"
aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="$VPC_NAME"

echo "=== [2] Creating Web Subnet ==="
WEB_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block $CIDR_WEB \
  --region $REGION \
  --availability-zone "${REGION}a" \
  --query 'Subnet.SubnetId' \
  --output text)
echo "✅ Web Subnet created: $WEB_SUBNET_ID"
aws ec2 create-tags --resources "$WEB_SUBNET_ID" --tags Key=Name,Value="$WEB_SUBNET_NAME"

echo "=== [3] Creating DB Subnet ==="
DB_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block $CIDR_DB \
  --region $REGION \
  --availability-zone "${REGION}b" \
  --query 'Subnet.SubnetId' \
  --output text)
echo "✅ DB Subnet created: $DB_SUBNET_ID"
aws ec2 create-tags --resources "$DB_SUBNET_ID" --tags Key=Name,Value="$DB_SUBNET_NAME"

echo "=== [4] Creating IAM Groups ==="
aws iam create-group --group-name WebAdmins || echo "ℹ️ WebAdmins group may already exist."
aws iam create-group --group-name DBAdmins || echo "ℹ️ DBAdmins group may already exist."

echo "=== [5] Attaching IAM Policies ==="
aws iam attach-group-policy --group-name WebAdmins --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
aws iam attach-group-policy --group-name DBAdmins --policy-arn arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess

echo "=== [6] Creating Test Users ==="
aws iam create-user --user-name TestWebUser || echo "ℹ️ TestWebUser may already exist."
aws iam create-user --user-name TestDBUser || echo "ℹ️ TestDBUser may already exist."

aws iam add-user-to-group --user-name TestWebUser --group-name WebAdmins
aws iam add-user-to-group --user-name TestDBUser --group-name DBAdmins

echo ""
echo "✅ Deployment completed successfully!"
echo "-----------------------------------------"
echo "Region:          $REGION"
echo "VPC_ID:          $VPC_ID"
echo "WEB_SUBNET_ID:   $WEB_SUBNET_ID"
echo "DB_SUBNET_ID:    $DB_SUBNET_ID"
echo "-----------------------------------------"
