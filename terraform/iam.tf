# Defines the role Lamda can assume.
resource "aws_iam_role" "lambda_exec" {
    name = "${var.project_name}-lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "lambda.amazonaws.com"}
        }]
    })
}

# Enable Lambda to write to CloudWatch.
resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Enable Lambda to call Rekognition and Secrets Manager.
resource "aws_iam_role_policy" "lambda_permissions" {
    name = "${var.project_name}-lambda-policy"
    role = aws_iam_role.lambda_exec.id

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = ["rekognition:DetectLabels"]
        Resource = "*"
    },
    {
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:us-east-1:688933601990:secret:pipelineiq/db-*"
    },
    {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = "arn:aws:s3:::pipelineiq--uploads-01f810ed/*"
    },
    {
    Effect = "Allow"
    Action = ["ec2:CreateNetworkInterface","ec2:DescribeNetworkInterfaces","ec2:DeleteNetworkInterface"]
    Resource = "*"
    }]
})
}