### Roboshop
## Launch EC2 fro launch Templates

# Frontend(web/ui)
aws ec2 run-instances \
  --launch-template LaunchTemplateId=lt-093b6d202fa34939d,Version='$Default' \
  --count 1

# AL2023 - App Tier
aws ec2 run-instances \
  --launch-template LaunchTemplateId=lt-0aa5b1d868d1cbb86,Version='$Default' \
  --count 1

#  AL2023 -  DB Tiee
aws ec2 run-instances \
  --launch-template LaunchTemplateId=lt-0f103401ed25df3bb,Version='$Default' \
  --count 2

# centos - DB Tier
aws ec2 run-instances \
  --launch-template LaunchTemplateId=lt-072ea4fc022c05b02,Version='$Default' \
  --count 1 &&

# centos - App Tier
aws ec2 run-instances \
  --launch-template LaunchTemplateId=lt-05065501c9654fdda,Version='$Default' \
  --count 1

#-------------------------------------------------------------------

## Execute SSM on EC2

ec2_id="i-0756292cd0d90d937"
yaml_file="10_payment.yaml"

aws ssm send-command \
  --document-name "AWS-ApplyAnsiblePlaybooks" \
  --document-version "1" \
  --targets "Key=InstanceIds,Values=${ec2_id}" \
  --parameters "{
      \"SourceType\": [\"GitHub\"],
      \"SourceInfo\": [\"{\\\"owner\\\":\\\"kvmuralikrishna9\\\",\\\"repository\\\":\\\"practise_devops\\\",\\\"path\\\":\\\"roboshop/3_roboshop_ansible\\\",\\\"getOptions\\\":\\\"branch:feature-murali\\\"}\"],
      \"InstallDependencies\": [\"True\"],
      \"PlaybookFile\": [\"${yaml_file}\"],
      \"ExtraVariables\": [\"SSM=True\"],
      \"Check\": [\"False\"],
      \"Verbose\": [\"-vvv\"],
      \"TimeoutSeconds\": [\"3600\"]
  }" \
  --timeout-seconds 600 \
  --max-concurrency "50" \
  --max-errors "0" \
  --output-s3-bucket-name "ssm-bucket-practise" \
  --region us-east-1
