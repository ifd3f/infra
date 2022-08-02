// Uploads storage
resource "b2_bucket" "labnotes" {
  bucket_name = "labnotes-astrid-tech-media"
  bucket_type = "allPublic"
}

resource "b2_application_key" "labnotes" {
  key_name     = "labnotes-pleroma"
  bucket_id    = b2_bucket.labnotes.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "remote_file" "labnotes" {
  provider = remote.contabo

  path        = "/etc/labnotes.env"
  content     = <<-EOF
    B2_APP_KEY=${b2_application_key.labnotes.application_key}
    B2_APP_KEY_ID=${b2_application_key.labnotes.application_key_id}
    B2_BUCKET=${b2_bucket.labnotes.bucket_name}
  EOF
  permissions = "0600"
}

resource "cloudflare_record" "labnotes_akkoma" {
  name    = "labnotes"
  proxied = false
  type    = "A"
  value   = local.contabo_ip
  zone_id = cloudflare_zone.primary.id
}

