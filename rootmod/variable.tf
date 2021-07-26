variable "rgname" {
    type = string
          }
variable "region" {
    type = string
          }
variable "prefix" {
  type    = string
 }

variable "ssh-source-address" {
  type    = string
  default = "*"
}