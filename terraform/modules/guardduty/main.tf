resource "aws_guardduty_detector" "this" {
  enable = var.enable

  dynamic "datasources" {
    for_each = var.enable_s3_protection || var.enable_kubernetes_protection || var.enable_malware_protection ? [1] : []
    content {
      s3_logs {
        enable = var.enable_s3_protection
      }
      kubernetes {
        audit_logs {
          enable = var.enable_kubernetes_protection
        }
      }
      malware_protection {
        scan_ec2_instance_with_findings {
          ebs_volumes {
            enable = var.enable_malware_protection
          }
        }
      }
    }
  }

  tags = var.tags
}