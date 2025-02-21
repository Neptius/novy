import Config

# Configure your database
config :novy, Novy.Repo,
  username: "postgres",
  password: "pass",
  hostname: "localhost",
  database: "novy_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
