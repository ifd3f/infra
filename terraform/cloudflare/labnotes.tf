resource "b2_application_key" "labnotes" {
  key_name     = "labnotes-astrid-tech"
  bucket_id    = b2_bucket.media_bucket.id
  name_prefix  = "labnotes/"
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "remote_file" "labnotes" {
  provider = remote.contabo

  path        = "/etc/appkeys/labnotes.env"
  content     = <<-EOF
    B2_APP_KEY=${b2_application_key.application_key}
    B2_APP_KEY_ID=${b2_application_key.application_key_id}
    B2_BUCKET_ENDPOINT=${b2_application_key.application_key_id}
    B2_BUCKET_PREFIX=${b2_application_key.name_prefix}
  EOF
  permissions = "0600"
}

