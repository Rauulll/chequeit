# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :chequeit,
  ecto_repos: [Chequeit.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :chequeit, ChequeitWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ChequeitWeb.ErrorHTML, json: ChequeitWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Chequeit.PubSub,
  live_view: [signing_salt: "loSy8rQo"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :chequeit, Chequeit.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  chequeit: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  chequeit: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

#Environment Variables
config :chequeit, ChequeitWeb.Endpoint,
  appwrite_secret: "f30f34d6f35853f9966205e8b628538dbfe6bddd8c72686fa69897b1ac14ec60f189c45722bc23752d734634a7229affd24b387a239540332d76ac2df8ae31dab56cbab0d9589f3f60b07fa441e10114cf600ddf66a8795c674c7cf411acc7f792f6ca492ac0d20628edd26c1c999b0d96428a9a3e8b88bef7597f86333cf760",
  appwrite_project_id: "66c447850018d37b386c",
  fixed_namespace_uuid: "6111b8d8-efa1-4365-963a-d2fd54f53737"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
