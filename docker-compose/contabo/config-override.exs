import Config

config :pleroma, :frontends,
  primary: %{
    "name" => "pleroma-fe",
    "ref" => "develop"
  },
  admin: %{
    "name" => "admin-fe",
    "ref" => "develop"
  },
  swagger: %{
    "name" => "swagger-ui",
    "ref" => "stable",
    "enabled" => true
  } 

config :pleroma, :frontend_configurations,
  pleroma_fe: %{
    theme: "pleroma-dark",
    # ... see /priv/static/static/config.json for the available keys.
},
  masto_fe: %{
    showInstanceSpecificPanel: true
  }

config :pleroma, :static_fe,
  enabled: true

config :pleroma, Pleroma.Web.Endpoint,
  url: [host: System.get_env("DOMAIN", "localhost"), scheme: "https", port: 443],
  http: [ip: {0, 0, 0, 0}, port: 4000]

config :pleroma, :instance,
  registrations_open: false

# S3 upload setup
config :pleroma, Pleroma.Upload,
  base_url: "https://labnotes.astrid.tech",
  uploader: Pleroma.Uploaders.S3,
  strip_exif: false

config :ex_aws, :s3,
  access_key_id: System.get_env("B2_APP_KEY_ID"),
  secret_access_key: System.get_env("B2_APP_KEY"),
  host: "s3.us-west-000.backblazeb2.com"

config :pleroma, Pleroma.Uploaders.S3,
  bucket: System.get_env("B2_BUCKET")

config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER", "pleroma"),
  password: System.fetch_env!("DB_PASS"),
  database: System.get_env("DB_NAME", "pleroma"),
  hostname: System.get_env("DB_HOST", "db"),
  pool_size: 10
