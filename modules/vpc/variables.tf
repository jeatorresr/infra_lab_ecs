variable "name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "cidr_block" {
  description = "Bloque CIDR para la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Bloques CIDR para las subnets públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Bloques CIDR para las subnets privadas"
  type        = list(string)
}
