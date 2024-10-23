import Config

# Configure your database
config :novy, Novy.Repo,
  username: "postgres",
  password: "password",
  hostname: "localhost",
  database: "novy_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :assent,
  discord: [
    client_id: "XXXXXXXXXXXXX",
    client_secret: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
    redirect_uri: "http://localhost:4000/auth/discord/callback"
  ]
