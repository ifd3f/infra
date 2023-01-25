resource "b2_bucket" "nextcloud" {
  bucket_name = "ifd3f-nextcloud"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "nextcloud_storage" {
  key_name     = "nextcloud-secret-key"
  bucket_id    = b2_bucket.nextcloud.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "random_password" "nextcloud_admin_pass" {
  length  = 32
  special = false
}

resource "vault_kv_secret_v2" "nextcloud_s3_key" {
  mount = "kv"
  name  = "nextcloud/secrets"
  data_json = jsonencode(
    {
      s3_key    = b2_application_key.nextcloud_storage.application_key_id
      s3_secret = b2_application_key.nextcloud_storage.application_key
      adminpass = random_password.nextcloud_admin_pass.result
    }
  )
  custom_metadata {
    max_versions = 1
  }
}
