provider "aws" {
  region = "ap-southeast-1" # Adjust as needed
}

variable "labss3contentbucket" {
  description = "Bucket for labs s3 content"
  default     = "cl-labs-s3content"
}

variable "labss3contentprefix" {
  description = "Bucket for labs s3 content"
  default     = "aws-cognito-web-identity-federation/appbucket"
}


