resource local_file "example" {
  content  = "Hello, Terraform!WXYZ"
  filename = "${path.module}/hello3.txt"

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
    ignore_changes = [content]
  }
}