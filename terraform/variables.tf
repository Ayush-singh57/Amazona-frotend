variable "aws_region" {
  default = "ap-south-1"
}

# We add "-ui" so it doesn't conflict with your backend bucket names!
variable "project_name" {
  default = "amazona-prod-ui" 
}