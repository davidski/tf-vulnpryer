provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
  version = "~> 1.54"

  assume_role {
    role_arn = "arn:aws:iam::754135023419:role/administrator-service"
  }
}

provider "aws.east_1" {
  region  = "us-east-1"
  profile = "${var.aws_profile}"

  assume_role {
    role_arn = "arn:aws:iam::754135023419:role/administrator-service"
  }
}

# Data source for the availability zones in this zone
data "aws_availability_zones" "available" {}

# Data source for current account number
data "aws_caller_identity" "current" {}

# Data source for ACM certificate
data "aws_acm_certificate" "vulnpryer" {
  provider = "aws.east_1"
  domain   = "vulnpryer.net"
}

data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket  = "infrastructure-severski"
    key     = "terraform/infrastructure.tfstate"
    region  = "us-west-2"
    encrypt = "true"
  }
}

/*
  --------------------------
  | CloudFront Distributon |
  --------------------------
*/

resource "aws_cloudfront_distribution" "vp" {
  origin {
    origin_id   = "myGithubOrigin"
    domain_name = "davidski.github.io"
    origin_path = "/VulnPryer"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${data.terraform_remote_state.main.auditlogs}.s3.amazonaws.com"
    prefix          = "cloudfront/vulnpryer"
  }

  aliases = ["www.vulnpryer.net", "vulnpryer.net"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myGithubOrigin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Name       = "VP CloudFront"
    project    = "${var.project}"
    managed_by = "Terraform"
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.vulnpryer.arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}
