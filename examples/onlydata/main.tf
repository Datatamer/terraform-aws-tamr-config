# data "aws_ami" "tamr-vm" {
#   most_recent = true
#   owners      = ["679593333241"]
#   name_regex  = "^Ubuntu 18.04 Tamr.*"
#   filter {
#     name   = "product-code"
#     values = ["832nkbrayw00cnivlh6nbbi6p"]
#   }
#   filter {
#     name   = "product-code.type"
#     values = ["marketplace"]
#   }
# }

data "aws_ami" "tamr-vm" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
   }
