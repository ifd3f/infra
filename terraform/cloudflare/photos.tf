// Uploads storage
resource "b2_bucket" "photos" {
  bucket_name = "astrid-tech-photos"
  bucket_type = "allPublic"
}

resource "b2_application_key" "photos" {
  key_name     = "photos"
  bucket_id    = b2_bucket.photos.id
  capabilities = ["deleteFiles", "listBuckets", "listFiles", "readBucketEncryption", "readBucketReplications", "readBuckets", "readFiles", "shareFiles", "writeBucketEncryption", "writeBucketReplications", "writeFiles"]
}
