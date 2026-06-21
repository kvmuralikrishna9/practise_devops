    # Terraform Commands Cheat Sheet

## Initialization

```bash
terraform init                              # Initialize Terraform
terraform init -reconfigure                 # Reconfigure Backend
terraform init -upgrade                     # Upgrade Provider Versions
```

## Format & Validate

```bash
terraform fmt                               # Format Terraform Files
terraform fmt -recursive                    # Format All Terraform Files
terraform fmt -check                        # Check Formatting Only
terraform validate                          # Validate Configuration
```

## Plan

```bash
terraform plan                              # Generate Execution Plan
terraform plan -var-file=dev.tfvars         # Use Variable File
terraform plan -out=tfplan                  # Save Execution Plan
terraform plan -destroy                     # Preview Destroy
terraform plan -refresh-only                # Refresh State Only
terraform plan -target=aws_instance.web     # Plan Changes For Specific Resource
```

## Apply

```bash
terraform apply                             # Apply Infrastructure Changes
terraform apply tfplan                      # Apply Saved Plan
terraform apply -auto-approve               # Apply Without Confirmation
terraform apply -refresh-only               # Refresh State & Update State
terraform apply -target=aws_instance.web    # Apply Changes To Specific Resource
```

## Destroy

```bash
terraform destroy                           # Destroy Infrastructure
terraform destroy -var-file=dev.tfvars      # Destroy Using tfvars File
terraform destroy -auto-approve             # Destroy Without Confirmation
terraform destroy -target=aws_instance.web  # Destroy Specific Resource Only
```

## Outputs

```bash
terraform output                            # Show All Outputs
terraform output instance_id                # Show Specific Output
terraform output -json                      # Output JSON Format
```

## State Commands

```bash
terraform state list                        # List Resources In State
terraform state show aws_instance.web       # Show Resource Details
terraform state rm aws_instance.web         # Remove Resource From State
terraform state mv old new                  # Rename Resource In State
terraform state pull                        # Pull Remote State
terraform state push terraform.tfstate      # Push State To Backend
```

## Import

```bash
terraform import aws_instance.web i-123456789
terraform import aws_security_group.sg sg-123456
```

## Workspaces

```bash
terraform workspace show                    # Show Current Workspace
terraform workspace list                    # List Workspaces
terraform workspace new dev                 # Create Workspace
terraform workspace select dev              # Switch Workspace
terraform workspace delete dev              # Delete Workspace
```

## Providers

```bash
terraform providers                         # Show Providers Used
terraform providers schema -json            # Show Provider Schema
```

## Show Commands

```bash
terraform show                              # Show Current State
terraform show tfplan                       # Show Saved Plan
terraform version                           # Show Terraform Version
```

## Console

```bash
terraform console                           # Interactive Terraform Console
```

## Debugging

```bash
export TF_LOG=DEBUG                         # Enable Debug Logs
unset TF_LOG                                # Disable Debug Logs
```

## Cleanup

```bash
rm -rf .terraform                           # Remove Downloaded Providers
rm -f .terraform.lock.hcl                   # Remove Lock File
terraform init                              # Reinitialize Terraform
```

## Development Workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

## Production Workflow

```bash
terraform fmt -check
terraform validate
terraform plan -out=tfplan -var-file=prod.tfvars
terraform apply tfplan
```

## Interview Must-Know Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
terraform output
terraform state list
terraform state show
terraform import
terraform workspace
terraform console
terraform providers
```
