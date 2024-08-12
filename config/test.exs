import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :novy_web, NovyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9ZP17L98Uhq6wyoGySTR0XXuQBm9Glmyw3WCxp7FNi7fbuIGXyRqAc66sT2VgPiR",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails
config :novy, Novy.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

import_config "test.secret.exs"
