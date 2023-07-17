// Uploads storage
resource "b2_application_key" "main_fedi" {
  key_name     = "main-fedi"
  bucket_id    = b2_bucket.fedi.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "vault_kv_secret_v2" "akkoma_b2" {
  mount = "kv"
  name  = "akkoma_b2/secrets"
  data_json = jsonencode(
    {
      b2_app_key_id = b2_application_key.loki_storage_v2.application_key_id
      b2_app_key = b2_application_key.loki_storage_v2.application_key
    }
  )
  custom_metadata {
    max_versions = 1
  }
}
