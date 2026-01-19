variable "client" {
	description = "Client's name"
	type = string
	default = null
}
variable "secret_key" {
  description = "JWT secret key"
  type        = string
  sensitive   = true
}

variable "algorithm" {
  description = "JWT algorithm"
  type        = string
  default     = "HS256"
}

variable "access_token_expire_minutes" {
  description = "JWT access token expiration time in minutes"
  type        = number
  default     = 120
}

variable "database_driver" {
  type    = string
  default = "postgresql"
}

variable "database_username" {
  type      = string
  sensitive = true
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "database_host" {
  type    = string
  default = "database"
}

variable "database_port" {
  type    = number
  default = 5432
}

variable "database_name" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "admin_name" {
  type = string
}
