module "this" {
    source = "terraform-aws-modules/lambda/aws"
    version = "7.2.1"

    create = var.create
    create_package = var.create_package
    create_function = true
    create_layer = var.create_layer
    create_role = var.create_role
    create_lambda_function_url = var.create_lambda_function_url
    create_sam_metadata = var.create_sam_metadata
    putin_khuylo = var.putin_khuylo

    lambda_at_edge = var.lambda_at_edge
    lambda_at_edge_logs_all_regions = var.lambda_at_edge_logs_all_regions
    function_name = var.function_name
    handler = "bootstrap"
    runtime = "provided.al2"
    lambda_role = var.lambda_role
    description = var.description
    code_signing_config_arn = var.code_signing_config_arn
    layers = var.layers
    architectures = var.architectures
    kms_key_arn = var.kms_key_arn
    memory_size = var.memory_size
    ephemeral_storage_size = var.ephemeral_storage_size
    publish = var.publish
    reserved_concurrent_executions = var.reserved_concurrent_executions
    timeout = var.timeout
    dead_letter_target_arn = var.dead_letter_target_arn
    environment_variables = var.environment_variables
    tracing_mode = var.tracing_mode
    vpc_subnet_ids = var.vpc_subnet_ids
    vpc_security_group_ids = var.vpc_security_group_ids
    tags = var.tags
    function_tags = var.function_tags
    s3_object_tags = var.s3_object_tags
    s3_object_tags_only = var.s3_object_tags_only
    package_type = var.package_type
    image_uri = var.image_uri
    image_config_entry_point = var.image_config_entry_point
    image_config_command = var.image_config_command
    image_config_working_directory = var.image_config_working_directory
    snap_start = var.snap_start
    replace_security_groups_on_destroy = var.replace_security_groups_on_destroy
    replacement_security_group_ids = var.replacement_security_group_ids
    timeouts = var.timeouts

    create_unqualified_alias_lambda_function_url = var.create_unqualified_alias_lambda_function_url
    authorization_type = var.authorization_type
    cors = var.cors
    invoke_mode = var.invoke_mode
    s3_object_override_default_tags = var.s3_object_override_default_tags

    create_current_version_allowed_triggers = var.create_current_version_allowed_triggers
    create_unqualified_alias_allowed_triggers = var.create_unqualified_alias_allowed_triggers
    allowed_triggers = var.allowed_triggers

    use_existing_cloudwatch_log_group = var.use_existing_cloudwatch_log_group
    cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
    cloudwatch_logs_kms_key_id = var.cloudwatch_logs_kms_key_id
    cloudwatch_logs_tags = var.cloudwatch_logs_tags
    
    role_name = var.role_name
    role_description = var.role_description
    role_path = var.role_path
    role_force_detach_policies = var.role_force_detach_policies
    role_permissions_boundary = var.role_permissions_boundary
    role_tags = var.role_tags
    role_maximum_session_duration = var.role_maximum_session_duration

    policy_name = var.policy_name
    attach_cloudwatch_logs_policy = var.attach_cloudwatch_logs_policy
    attach_create_log_group_permission = var.attach_create_log_group_permission
    attach_dead_letter_policy = var.attach_dead_letter_policy
    attach_network_policy = var.attach_network_policy
    attach_tracing_policy = var.attach_tracing_policy
    attach_async_event_policy = var.attach_async_event_policy
    attach_policy_json = var.attach_policy_json
    attach_policy_jsons = var.attach_policy_jsons
    attach_policy = var.attach_policy
    attach_policies = var.attach_policies
    policy_path = var.policy_path
    number_of_policy_jsons = var.number_of_policy_jsons
    number_of_policies = var.number_of_policies
    attach_policy_statements = var.attach_policy_statements
    trusted_entities = var.trusted_entities
    assume_role_policy_statements = var.assume_role_policy_statements
    policy_json = var.policy_json
    policy_jsons = var.policy_jsons
    policy = var.policy
    policies = var.policies
    policy_statements = var.policy_statements
    file_system_arn = var.file_system_arn
    file_system_local_mount_path = var.file_system_local_mount_path

    logging_log_format = var.logging_log_format
    logging_application_log_level = var.logging_application_log_level
    logging_system_log_level = var.logging_system_log_level
    logging_log_group = var.logging_log_group
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command =<<EOT
docker run --rm \
    -u $(id -u):$(id -g) \
    -v ${var.source_path}:/code/${var.source_path} \
    ${join(" ", [for path in var.source_libraries_path : "-v ${path}:code/${path}"])} \
    -v ${HOME}/.cargo/registry:/cargo/registry \
    -v ${HOME}/.cargo/git:/cargo/git \
    -w /code/${var.source_path} \
    softprops/lambda-rust
EOT

    working_dir = var.source_path
    environment = {
        PACKAGE: true,
        BIN: var.function_name
    }
    quiet = false
  }
}
