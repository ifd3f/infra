resource "b2_bucket" "fedi" {
  bucket_name = "nyaabucket"
  bucket_type = "allPublic"
}

resource "b2_bucket" "logging" {
  bucket_name = "ifd3f-logging"
  bucket_type = "allPublic"
}

resource "b2_bucket" "backup" {
  bucket_name = "ifd3f-backup"
  bucket_type = "allPrivate"
}
