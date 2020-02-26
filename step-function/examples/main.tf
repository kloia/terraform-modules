module "my_step_function" {
    source = "../"
    state_machine_name = "demo-step-function-tf"
    definition_content = "${file("${path.module}/config/definition.json")}"
}
