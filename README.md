# Couchbase AWS Scripts

This repository can be used to create an EC2 instance where you will setup a Couchbase cluster.


## Specification

The following specs are hard-coded.
- Instance Type: t2.medium
- OS: RHEL-7.7_HVM-20191119-x86_64-2-Hourly2-GP2
- OS User: ec2-user

- Region: us-east-2

### AMI ID

Sample:
- US East (Ohio): ami-0170fc126935d44c3

## Prerequisite
You have an local environment where you can run AWS CLI as well as the AWS environment where you will create your Cloudera cluster.

## Preparation

Please replace `%YOUR_...%` in `instance_couchbase.json` with the values for your AWS environment.

```
    "KeyName": "%YOUE_KEY_NAME%",
    "SecurityGroupIds": [
         "%YOUR_SECURITY_GROUP_ID%"
    ],
...
    "SubnetId": "%YOUR_SUBNET_ID%",
```

Please replace `%YOUR_...%` in `cluster_couchbase.sh` with the values for your AWS environment.

```
KEY_NAME=~/%YOUR_KEY_NAME%
```

Please also replace `%..._AS_YOU_LIKE%` in `cluster_couchbase.sh` with any appropriate values.

```
TAG_PROJECT=%PROJECT_AS_YOU_LIKE%
TAG_OWNER=%OWNER_AS_YOU_LIKE%
INSTANCE_NAME=%INSTANCE_NAME_AS_YOU_LIKE%
```

## Run

Execute `cluster_couchbase.sh` on your local environment.
```
$ cluster_couchbase.sh 
```

Upon successful completion of the above script, you would find a new instance is created on AWS Web Console.

## Misc

When you execute the above script, you would find `passwordless_<INSTANCE_NAME_AS_YOU_LIKE>_<DATA_TIME>.sh` is generated locally.
You can use this script to enable passwordless (no need to use PEM file) login. You don't have to mind it necessarily for an instance.
This is a "sugar coating" function for when dealing with multiple instances in a script.
