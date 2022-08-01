import config

config :pleroma, :instance,
  registrations_open: false

# S3 upload setup
config :ex_aws, :s3,
  access_key_id: System.get_env("S3_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("S3_ACCESS_KEY_SECRET"),
  host: System.get_env("S3_HOST")

config :pleroma, Pleroma.Uploaders.S3,
  bucket: System.get_env("S3_BUCKET"),
  public_endpoint: System.get_env("S3_PUBLIC_ENDPOINT")

