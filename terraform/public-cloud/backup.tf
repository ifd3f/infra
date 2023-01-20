locals {
  backup_hosts = toset([
    "diluc.h.astrid.tech",
    "amiya.h.astrid.tech",
    "yato.h.astrid.tech",
    "durin.h.astrid.tech",
  ])
}

resource "b2_application_key" "backup_storage" {
  for_each = local.backup_hosts

  key_name     = replace("backup-storage-key-${each.key}", ".", "-")
  bucket_id    = b2_bucket.backup.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}

resource "random_password" "restic_repo_password" {
  for_each = local.backup_hosts

  length  = 32
  special = false
}

resource "vault_kv_secret_v2" "backup_env" {
  for_each = local.backup_hosts

  mount = "kv"
  name  = "backup-${each.key}/environment"
  data_json = jsonencode(
    {
      AWS_ACCESS_KEY_ID     = b2_application_key.backup_storage[each.key].application_key_id
      AWS_SECRET_ACCESS_KEY = b2_application_key.backup_storage[each.key].application_key
    }
  )
  custom_metadata {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "backup_repo_password" {
  for_each = local.backup_hosts

  mount = "kv"
  name  = "backup-${each.key}/secrets"
  data_json = jsonencode(
    {
      repo_password = random_password.restic_repo_password[each.key].result
    }
  )
  custom_metadata {
    max_versions = 5
  }
}
