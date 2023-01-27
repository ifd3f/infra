resource "b2_application_key" "loki_storage_v2" {
  key_name     = "loki-storage-key-v2"
  bucket_id    = b2_bucket.logging.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "vault_kv_secret_v2" "loki_server_secrets" {
  mount = "kv"
  name  = "loki-server/environment"
  data_json = jsonencode(
    {
      S3_ACCESS = b2_application_key.loki_storage_v2.application_key_id
      S3_SECRET = b2_application_key.loki_storage_v2.application_key
    }
  )
  custom_metadata {
    max_versions = 1
  }
}
