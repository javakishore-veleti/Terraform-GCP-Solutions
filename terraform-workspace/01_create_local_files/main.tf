resource local_file sample_resource {
  filename = "${path.module}/example.txt"
  content = "This is an example file created by Terraform."
}

resource local_file resource_one {
  filename = "${path.module}/resource_one.txt"
  content  = "This is resource one."
}

resource local_file resource_two {
  filename = "${path.module}/resource_two.txt"
  content  = "This is resource two."
}