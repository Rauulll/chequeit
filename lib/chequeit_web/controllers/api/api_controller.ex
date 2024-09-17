defmodule ChequeitWeb.Api.ApiController do
  import Plaid
  use ChequeitWeb, :controller

  def appwrite_project_id do
    Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_project_id) |> Keyword.get(:appwrite_project_id)
  end

  def appwrite_key do
    Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_secret) |> Keyword.get(:appwrite_secret)
  end

  def plaid_config do
    client_id = get_plaid_client_id()
    client_secret = get_plaid_client_secret()
    [client_id: client_id, secret: client_secret]
  end

  defp get_plaid_client_id(), do: Application.get_env(:elixir_plaid, :client_id)

  defp get_plaid_client_secret(), do: Application.get_env(:elixir_plaid, :client_secret)
end
