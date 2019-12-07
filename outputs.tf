output "cloudfront_id" {
  value = aws_cloudfront_distribution.vp.id
}

output "cloudfront_dns" {
  value = aws_cloudfront_distribution.vp.domain_name
}
