resource random_integer random_int {
  min = 1
  max = 100
}

output name {
    value = random_integer.random_int.result
    sensitive = false
    description = "description of the output"
  depends_on = []
}