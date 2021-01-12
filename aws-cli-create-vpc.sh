#!/bin/bash
#******************************************************************************
#    AWS VPC Creation Shell Script
#******************************************************************************
#
# SYNOPSIS
#    Automates the creation of a custom IPv4 VPC, having both with two public and
#    private subnet.
#
# DESCRIPTION
#    This shell script leverages the AWS Command Line Interface (AWS CLI) to
#    automatically create a custom VPC.  The script assumes the AWS CLI is
#    installed and configured with the necessary security credentials.
#
#==============================================================================
#
# NOTES
#   VERSION:   0.1.0
#   LASTEDIT:  03/18/2017
#   AUTHOR:    Joe Arauzo
#   EMAIL:     joe@arauzo.net
#   COLABORATES: Rafael Yanagui (rafael.yanagui@nanoincub.com.br(
#   REVISIONS:
#       0.1.0  03/18/2017 - first release
#       0.0.1  02/25/2017 - work in progress
#
#==============================================================================
#   MODIFY THE SETTINGS BELOW
#==============================================================================
#
ENVIROMENT="prod"
AWS_REGION="us-west-1"
PROJECT_NAME="project"
VPC_NAME="vpc_${PROJECT_NAME}"
VPC_CIDR="10.0.0.0/16"

SUBNET_PUBLIC1_CIDR="10.0.1.0/24"
SUBNET_PUBLIC1_AZ="${AWS_REGION}a"
SUBNET_PUBLIC1_NAME="subnet_${PROJECT_NAME}_${ENVIROMENT}_public_a"

SUBNET_PUBLIC2_CIDR="10.0.3.0/24"
SUBNET_PUBLIC2_AZ="${AWS_REGION}b"
SUBNET_PUBLIC2_NAME="subnet_${PROJECT_NAME}_${ENVIROMENT}_public_b"

SUBNET_PRIVATE1_CIDR="10.0.2.0/24"
SUBNET_PRIVATE1_AZ="${AWS_REGION}a"
SUBNET_PRIVATE1_NAME="subnet_${PROJECT_NAME}_${ENVIROMENT}_private_a"

SUBNET_PRIVATE2_CIDR="10.0.4.0/24"
SUBNET_PRIVATE2_AZ="${AWS_REGION}b"
SUBNET_PRIVATE2_NAME="subnet_${PROJECT_NAME}_${ENVIROMENT}_private_b"

ROUTER_TABLE_PUBLIC_NAME="rt_${PROJECT_NAME}_${ENVIROMENT}_public"
ROUTER_TABLE_PRIVATE_NAME="rt_${PROJECT_NAME}_${ENVIROMENT}_private"

INTERNET_GATEWAY_NAME="igw_${PROJECT_NAME}"

CHECK_FREQUENCY=5
#
#==============================================================================
#   DO NOT MODIFY CODE BELOW
#==============================================================================
#
# Create VPC
echo "Creating VPC in preferred region..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $AWS_REGION)
echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."

# Add Name tag to VPC
aws ec2 create-tags \
  --resources $VPC_ID \
  --tags "Key=Name,Value=$VPC_NAME" \
  --region $AWS_REGION
echo "  VPC ID '$VPC_ID' NAMED as '$VPC_NAME'."

# Create Public 1 Subnet
echo "Creating Public 1 Subnet..."
SUBNET_PUBLIC1_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC1_CIDR \
  --availability-zone $SUBNET_PUBLIC1_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PUBLIC1_ID' CREATED in '$SUBNET_PUBLIC1_AZ'" \
  "Availability Zone."

# Add Name tag to Public 1 Subnet
aws ec2 create-tags \
  --resources $SUBNET_PUBLIC1_ID \
  --tags "Key=Name,Value=$SUBNET_PUBLIC1_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PUBLIC1_ID' NAMED as '$SUBNET_PUBLIC1_NAME'."


# Create Public 2 Subnet
echo "Creating Public 2 Subnet..."
SUBNET_PUBLIC2_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC2_CIDR \
  --availability-zone $SUBNET_PUBLIC2_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PUBLIC2_ID' CREATED in '$SUBNET_PUBLIC2_AZ'" \
  "Availability Zone."

# Add Name tag to Public 2 Subnet
aws ec2 create-tags \
  --resources $SUBNET_PUBLIC2_ID \
  --tags "Key=Name,Value=$SUBNET_PUBLIC2_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PUBLIC2_ID' NAMED as '$SUBNET_PUBLIC2_NAME'."

# Create Private 1 Subnet
echo "Creating Private 1 Subnet..."
SUBNET_PRIVATE1_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE1_CIDR \
  --availability-zone $SUBNET_PRIVATE1_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PRIVATE1_ID' CREATED in '$SUBNET_PRIVATE1_AZ'" \
  "Availability Zone."

# Add Name tag to Private 1 Subnet
aws ec2 create-tags \
  --resources $SUBNET_PRIVATE1_ID \
  --tags "Key=Name,Value=$SUBNET_PRIVATE1_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PRIVATE1_ID' NAMED as '$SUBNET_PRIVATE1_NAME'."


# Create Private 2 Subnet
echo "Creating Private 2 Subnet..."
SUBNET_PRIVATE2_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE2_CIDR \
  --availability-zone $SUBNET_PRIVATE2_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PRIVATE2_ID' CREATED in '$SUBNET_PRIVATE2_AZ'" \
  "Availability Zone."

# Add Name tag to Private 2 Subnet
aws ec2 create-tags \
  --resources $SUBNET_PRIVATE2_ID \
  --tags "Key=Name,Value=$SUBNET_PRIVATE2_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PRIVATE2_ID' NAMED as '$SUBNET_PRIVATE2_NAME'."


# Create Internet gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $AWS_REGION)
echo "  Internet Gateway ID '$IGW_ID' CREATED."

# Add Name tag to Internet gateway
aws ec2 create-tags \
  --resources $IGW_ID \
  --tags "Key=Name,Value=$INTERNET_GATEWAY_NAME" \
  --region $AWS_REGION
echo "  Internet Gateway ID '$IGW_ID' NAMED as '$INTERNET_GATEWAY_NAME'."


# Attach Internet gateway to your VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $AWS_REGION
echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# Create Public Route Table 
echo "Creating Public Route Table..."
ROUTE_TABLE_PUBLIC_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $AWS_REGION)
echo "  Public Route Table ID '$ROUTE_TABLE_PUBLIC_ID' CREATED."

# Add Name tag to Public Route Table
aws ec2 create-tags \
  --resources $ROUTE_TABLE_PUBLIC_ID \
  --tags "Key=Name,Value=$ROUTER_TABLE_PUBLIC_NAME" \
  --region $AWS_REGION
echo "  Public Route Table ID '$ROUTE_TABLE_PUBLIC_ID' NAMED as '$ROUTER_TABLE_PUBLIC_NAME'."


# Create Private Route Table 
echo "Creating Private Route Table..."
ROUTE_TABLE_PRIVATE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $AWS_REGION)
echo "  Private Route Table ID '$ROUTE_TABLE_PRIVATE_ID' CREATED."


# Add Name tag to Private Route Table
aws ec2 create-tags \
  --resources $ROUTE_TABLE_PRIVATE_ID \
  --tags "Key=Name,Value=$ROUTER_TABLE_PRIVATE_NAME" \
  --region $AWS_REGION
echo "  Private Route Table ID '$ROUTE_TABLE_PRIVATE_ID' NAMED as '$ROUTER_TABLE_PRIVATE_NAME'."


# Create route to Internet Gateway
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_PUBLIC_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $AWS_REGION)
echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" \
  "Public Route Table ID '$ROUTE_TABLE_PUBLIC_ID'."

# Associate Publics Subnet with Public Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC1_ID \
  --route-table-id $ROUTE_TABLE_PUBLIC_ID \
  --region $AWS_REGION)
echo "  Public Subnet 1 ID '$SUBNET_PUBLIC1_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_PUBLIC_ID'."

RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC2_ID \
  --route-table-id $ROUTE_TABLE_PUBLIC_ID \
  --region $AWS_REGION)
echo "  Public Subnet 2 ID '$SUBNET_PUBLIC2_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_PUBLIC_ID'."

# Associate Privates Subnet with Private Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PRIVATE1_ID \
  --route-table-id $ROUTE_TABLE_PRIVATE_ID \
  --region $AWS_REGION)
echo "  Private Subnet 1 ID '$SUBNET_PRIVATE1_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_PRIVATE_ID'."

RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PRIVATE2_ID \
  --route-table-id $ROUTE_TABLE_PRIVATE_ID \
  --region $AWS_REGION)
echo "  Private Subnet 2 ID '$SUBNET_PRIVATE2_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_PRIVATE_ID'."

# Enable Auto-assign Public IP on Public 1 Subnet
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_PUBLIC1_ID \
  --map-public-ip-on-launch \
  --region $AWS_REGION
echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" \
  "'$SUBNET_PUBLIC1_ID'."

# Enable Auto-assign Public IP on Public 2 Subnet
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_PUBLIC2_ID \
  --map-public-ip-on-launch \
  --region $AWS_REGION
echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" \
  "'$SUBNET_PUBLIC2_ID'."

echo "COMPLETED"
