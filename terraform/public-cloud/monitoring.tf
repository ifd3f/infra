resource "b2_application_key" "loki_storage" {
  key_name     = "loki-storage-key"
  bucket_id    = b2_bucket.logging.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "remote_file" "loki_secrets_env" {
  provider = remote.durin

  path        = "/var/lib/secrets/loki/secrets.env"
  content     = <<EOF
    S3_ACCESS=${b2_application_key.loki_storage.application_key_id}
    S3_SECRET=${b2_application_key.loki_storage.application_key}
  EOF
  owner       = "loki"
  permissions = "0600"
}
