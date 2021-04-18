resource "aws_ecs_task_definition" "main" {
  family = var.family-name
  container_definitions = <<EOF
  [
    {
      "name": "repo-inferencer",
      "image": "${var.ecr_image_repo}:${var.ecr_image_tag}",
      "cpu": 0,
      "portMappings": [],
      "essential": true,
      "environment": [
          {
              "name": "DEVICE_NAME",
              "value": "${var.device_selector}"
          },
          {
              "name": "GROUP_ID",
              "value": "${var.kafka_group_id}"
          },
          {
              "name": "DATA_UPLOAD_EVENT",
              "value": "${var.kafka_data_upload_event}"
          },
          {
              "name": "KAFKA_BOOTSTRAP_SERVER_ONE",
              "value": "${var.kafka_bootstrap_server_one}"
          },
          {
              "name": "AWS_KEY",
              "value": "${var.aws_inferencer_key}"
          },
          {
              "name": "AWS_SECRET",
              "value": "${var.aws_inferencer_secret}"
          },
          {
              "name": "ENCODE_FORMAT",
              "value": "${var.kafka_encode_format}"
          },
          {
              "name": "PROCESS_RESULT_EVENT",
              "value": "${var.kafka_process_result_event}"
          },
          {
              "name": "BUCKET_NAME",
              "value": "${var.records_bucket_name}"
          },
          {
              "name": "MAPPER_URL",
              "value": "${var.mapper_url}"
          }
      ],
      "mountPoints": [],
      "volumesFrom": [],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "/ecs/monitor-inferencer",
              "awslogs-region": "us-east-1",
              "awslogs-stream-prefix": "ecs"
          }
      }
    }
  ]
  EOF

  cpu = "${var.cpu}"
  memory = "${var.memory}"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.monitor-inferencer-task-execution-role.arn
}