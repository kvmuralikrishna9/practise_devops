# Terraform Basic Terminology

## Block Types

Terraform configurations are made up of **blocks**.

### Resource Block

Used to create and manage infrastructure.

```hcl
resource "aws_instance" "web" {
}
```

* `resource` = Block Type
* `aws_instance` = Resource Type
* `web` = Resource Name

---

### Variable Block (Input Variable)

Used to accept input values.

```hcl
variable "instance_type" {
  type = string
}
```

Example:

```hcl
instance_type = var.instance_type
```

---

### Output Block

Used to display values after deployment.

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

---

### Data Block (Data Source)

Used to read existing resources from AWS.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
}
```

* `data` = Block Type
* `aws_ami` = Data Source Type
* `amazon_linux` = Data Source Name

---

### Provider Block

Used to configure the cloud provider.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

### Terraform Block

Used for backend and provider requirements.

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
```

---

### Module Block

Used to reuse Terraform code.

```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

---

# Quick Memory Tricks

| Concept                      | Terraform Keyword |
| ---------------------------- | ----------------- |
| User provides value          | variable          |
| Read existing AWS resource   | data              |
| Create new AWS resource      | resource          |
| Display value                | output            |
| Configure AWS provider       | provider          |
| Reusable code                | module            |
| Backend / Terraform settings | terraform         |

---

# Resource Example Breakdown

```hcl
resource "aws_instance" "vrp_test_ec2" {
}
```

| Item         | Meaning       |
| ------------ | ------------- |
| resource     | Block Type    |
| aws_instance | Resource Type |
| vrp_test_ec2 | Resource Name |

---

# Data Source Example Breakdown

```hcl
data "aws_key_pair" "main" {
}
```

| Item         | Meaning          |
| ------------ | ---------------- |
| data         | Block Type       |
| aws_key_pair | Data Source Type |
| main         | Data Source Name |

---

# Important Rule

Terraform does NOT have an `input` block.

The term **Input Variable** refers to a:

```hcl
variable "name" {
}
```

block.

Input Variable = Variable Block.
