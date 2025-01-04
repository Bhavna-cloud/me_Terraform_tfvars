#In Git-Terra

```
resource "aws_instance" "web-1" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "bhavna-key"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "bhavna"
    CostCenter = "ABCD"
  }
}
```

terraform apply --auto-approve

```
#output
 # aws_instance.web-1 will be created
  + resource "aws_instance" "web-1" {
```
```
change key_name = "bhavna-ke"

#output
  # aws_instance.web-1 must be replaced
-/+ resource "aws_instance" "web-1" {

Means first it will destroy, then create.
```

```
resource "aws_instance" "web-1" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "bhavna-ke"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "bhavna"
    CostCenter = "ABCD"
  }
  lifecycle{
    create_before_destroy = true
  }
}
```

