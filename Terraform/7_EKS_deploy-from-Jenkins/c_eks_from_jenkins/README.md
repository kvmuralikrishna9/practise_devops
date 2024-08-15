EKS Deployment Using Terraform

1. Before deploying EKS, Need to deploy S3-bucket and DynamoDB table from folder "S3-Dynamo-DB". 
    # terraform init
    # terraform validate
    # terraform plan -out=s3-dynamodb.tfplan

2. Once .tfstate, .tfplan & .tfstatebckup files created, execute   
    # terraform apply "s3-dynamodb.tfplan"
    # terraform apply

3. Once sucessful deployment of S3-bucket and DynamoDB table, execute the root moduele file "main.tf" using 
    # terraform init
    # terraform validate
    # terraform plan -out=eks-tf.tfplan

4. Once .tfstate, .tfplan & .tfstatebckup files created, execute   
    # terraform apply "eks-tf.tfplan"
    # terraform apply


5. Once infrastructure is deployed & and wanted to delete the particular resources,can perform

    Dry Run: # terraform plan -destroy -target=aws_instance.my_instance-resoure-id -refresh=false
               example : # terraform plan -destroy -target=aws_instance.my_instance-resoure-id

        By using the -target option with terraform destroy, you can manage your infrastructure more granularly
        and avoid unnecessary destruction of other resources.

6. Once dry run outputs results is as expected, can perfom
    # terraform destroy -target=aws_instance.my_instance-resoure-id


*** Not Recommended in Real-Time ***
7. If required we can destro the complete infrastructure
    # terraform destroy
    