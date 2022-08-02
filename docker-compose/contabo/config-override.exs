import config

config :pleroma, :instance,
  registrations_open: false

config :pleroma, :media_proxy,
  enabled: false,
  redirect_on_failure: true,
  base_url: "https://cache.domain.tld"

# S3 upload setup
config :pleroma, Pleroma.Upload,
  uploader: Pleroma.Uploaders.S3,
  strip_exif: true

config :ex_aws, :s3,
  access_key_id: System.get_env("B2_APP_KEY_ID"),
  secret_access_key: System.get_env("B2_APP_KEY"),
  host: "s3.us-west-000.backblazeb2.com"

config :pleroma, Pleroma.Uploaders.S3,
  bucket: System.get_env("B2_BUCKET"),
  public_endpoint: "https://s3.us-west-000.backblazeb2.com"
