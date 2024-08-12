resource "aws_sqs_queue" "karpenter_interruption_queue" {
  name                      = aws_eks_cluster.eks.name
  message_retention_seconds = 300
  sqs_managed_sse_enabled   = true
}

resource "aws_sqs_queue_policy" "karpenter_interruption_queue_policy" {
  queue_url = aws_sqs_queue.karpenter_interruption_queue.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "EC2InterruptionPolicy"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "events.amazonaws.com",
            "sqs.amazonaws.com"
          ]
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.karpenter_interruption_queue.arn
      }
    ]
  })

  depends_on = [
    aws_sqs_queue.karpenter_interruption_queue
  ]
}

resource "aws_cloudwatch_event_rule" "scheduled_change_rule" {
  name = "scheduled_change_rule"
  event_pattern = jsonencode({
    source        = ["aws.health"]
    "detail-type" = ["AWS Health Event"]
  })
}

resource "aws_cloudwatch_event_rule" "spot_interruption_rule" {
  name = "spot_interruption_rule"
  event_pattern = jsonencode({
    source        = ["aws.ec2"]
    "detail-type" = ["EC2 Spot Instance Interruption Warning"]
  })
}

resource "aws_cloudwatch_event_rule" "rebalance_rule" {
  name = "rebalance_rule"
  event_pattern = jsonencode({
    source        = ["aws.ec2"]
    "detail-type" = ["EC2 Instance Rebalance Recommendation"]
  })
}

resource "aws_cloudwatch_event_rule" "instance_state_change_rule" {
  name = "instance_state_change_rule"
  event_pattern = jsonencode({
    source        = ["aws.ec2"]
    "detail-type" = ["EC2 Instance State-change Notification"]
  })
}

resource "aws_cloudwatch_event_target" "scheduled_change_target" {
  rule      = aws_cloudwatch_event_rule.scheduled_change_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "spot_interruption_target" {
  rule      = aws_cloudwatch_event_rule.spot_interruption_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "rebalance_target" {
  rule      = aws_cloudwatch_event_rule.rebalance_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "instance_state_change_target" {
  rule      = aws_cloudwatch_event_rule.instance_state_change_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
}