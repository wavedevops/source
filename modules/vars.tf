variable "subnets" {
  type        = map(string)
  default     = {
    us-east-1b = "subnet-084d096cd8e354551"
    us-east-1d = "subnet-00e05b15c4116939b"
    us-east-1a = "subnet-0d6f188df6ab4cfee"
    us-east-1c = "subnet-0969c012e3344c524"
    us-east-1e = "subnet-020eec5c0a3cff8ca"
    us-east-1f = "subnet-05821032acb47d88c"
  }
}
