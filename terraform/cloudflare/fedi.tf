// Uploads storage
resource "b2_application_key" "main_fedi" {
  key_name     = "main-fedi"
  bucket_id    = b2_bucket.fedi.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "remote_file" "main_fedi_b2_app_key" {
  provider = remote.diluc

  path        = "/var/lib/secrets/akkoma/b2_app_key"
  content     = b2_application_key.main_fedi.application_key
  owner       = "akkoma"
  permissions = "0600"
}

resource "remote_file" "main_fedi_b2_app_key_id" {
  provider = remote.diluc

  path        = "/var/lib/secrets/akkoma/b2_app_key_id"
  content     = b2_application_key.main_fedi.application_key_id
  owner       = "akkoma"
  permissions = "0600"
}

resource "cloudflare_record" "main_fedi" {
  name    = "fedi"
  proxied = false
  type    = "A"
  value   = local.diluc_ip
  zone_id = cloudflare_zone.primary.id
}

