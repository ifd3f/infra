resource "b2_bucket" "fedi" {
  bucket_name = "nyaabucket"
  bucket_type = "allPublic"
}

resource "b2_bucket" "astrid_tech" {
  bucket_name = "astrid-tech-media"
  bucket_type = "allPublic"
}

