variable file_name {
    description = "The name of the file to create"
    type        = string
    default     = "default.txt"
}

variable file_path {
    description = "The path where the file will be created"
    type        = string
    default     = "./"
}

resource local_file create_file_name {
    filename = "${var.file_path}/${var.file_name}"
    content  = "This file is created with the name: ${var.file_name}\n"
}