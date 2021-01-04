variable "region" {
  type = string
}

variable "subnetID" {
    type = list(string)
    default = ["subnet-0d8c093e0a5777eed", "subnet-05d0f607ed3e3a266"]
}