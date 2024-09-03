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
  appwrite_secret: "dd60c1f0136c3a029fb366d47765eb907983dc6ae0c7c5ef08bd9f7d966445839e7ecec2f5b32c7d35bd1623ac2ad1c1ad34d71286f46a62a6fb09d0a85db38fd38461b0d89f14fc38880d3b7ca11916b4908ff78c6e3c5b06ecb472a603d61869d4ab3a91ed81ee8a3451652bb2f70e48cfd418d86bf231a4c3f6672a56ff69",
  appwrite_project_id: "66c447850018d37b386c",
  fixed_namespace_uuid: "f135c5f2-661e-11ef-8cda-dc7196b9e6e1"

config :sentry,
  dsn: "https://962c8bdbaacef7ea7b781179fc2ee5c2@o4507865332580352.ingest.de.sentry.io/4507865346408528",
  environment_name: Mix.env()


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
