defmodule Chequeit.Repo do
  use Ecto.Repo,
    otp_app: :chequeit,
    adapter: Ecto.Adapters.Postgres
end
