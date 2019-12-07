/*
  -----------------
  | VulnPryer DNS |
  -----------------
*/

resource "aws_route53_zone" "vulnpryer" {
  name = "vulnpryer.net."

  tags = {
    managed_by = "Terraform"
    project    = var.project
  }
}

resource "aws_route53_record" "vulnpryer" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = "google-site-verification"
  type    = "TXT"
  ttl     = 120
  records = ["_KY4IDzhSaKmyHvIj140118IbrxIHqZbR5nK0DJ_Mq8"]
}

resource "aws_route53_record" "vulnpryerDKIM" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = "google._domainkey"
  type    = "TXT"
  ttl     = 120

  records = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqFgB0YJT8X6WD7/+oh7/839Ui/BwlMxrHRY/9J+os3df36vq0FuWJs/VYSK7BtWg8j0+YyFWBcloDwVdmLl2hGX3s5429AesHCwtYPueYEwSkWMnIqLPph+nPFTUsx9NEAYYYVJxEawpYPM9Kdbv7eo/7oeXfXpHrFQKR5GHBPPxCCJVqxwdb5L\" \"9Ch+nJ+fvIPPaogV/GE12YmnhCnyliy9KCPliqVk4vJf9hdu/Ep262pzcp85/vAIQNhcdiE4B/hmz1DVJGtZMmbjcqIvTwSCBEE6EmWKdTawdh9oTbTxcdi4pHSCiQFC7ImtBG9ZR9wYEpGJkOs2JkFm5prz5pQIDAQAB"]
}

resource "aws_route53_record" "vulnpryerMX" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = aws_route53_zone.vulnpryer.name
  type    = "MX"
  ttl     = "300"

  records = [
    "10 ASPMX.L.GOOGLE.COM.",
    "20 ALT1.ASPMX.L.GOOGLE.COM.",
    "30 ALT2.ASPMX.L.GOOGLE.COM.",
    "40 ASPMX2.GOOGLEMAIL.COM.",
    "50 ASPMX3.GOOGLEMAIL.COM.",
  ]
}

/*
  ------------------------
  | VulnPryer V4 Records |
  ------------------------
*/

resource "aws_route53_record" "vulnpryer_gh" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = aws_route53_zone.vulnpryer.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.vp.domain_name
    zone_id                = aws_cloudfront_distribution.vp.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "vulnpryer_gh_www" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = "www.${aws_route53_zone.vulnpryer.name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.vp.domain_name
    zone_id                = aws_cloudfront_distribution.vp.hosted_zone_id
    evaluate_target_health = false
  }
}

/*
  ------------------------
  | VulnPryer V6 Records |
  ------------------------
*/

resource "aws_route53_record" "vulnpryer_gh_v6" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = aws_route53_zone.vulnpryer.name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.vp.domain_name
    zone_id                = aws_cloudfront_distribution.vp.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "vulnpryer_gh_www_v6" {
  zone_id = aws_route53_zone.vulnpryer.zone_id
  name    = "www.${aws_route53_zone.vulnpryer.name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.vp.domain_name
    zone_id                = aws_cloudfront_distribution.vp.hosted_zone_id
    evaluate_target_health = false
  }
}

/*
  -----------
  | Outputs |
  -----------
*/

output "vulnpryer_nameservers" {
  value = aws_route53_zone.vulnpryer.name_servers
}

output "vulnpryer_zoneid" {
  value = aws_route53_zone.vulnpryer.zone_id
}
