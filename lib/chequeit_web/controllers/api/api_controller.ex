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
     Application.get_env(:elixir_plaid, ChequeitWeb.Endpoint)
  end

  @doc """
  Gets credentials from configuration.
  """
  def get_cred do
    require_dwolla_credentials()
  end

  defp require_dwolla_credentials do
    case {get_client_id(), get_client_secret()} do
      {:not_found, _} ->
        raise message: """
              Client Id is missing. Please add client_secret to your config.exs file.

              config :dwolla, client_secret: "your_client_secret"
              """

      {_, :not_found} ->
        raise message: """
              Client secret is missing. Please add client_id to your config.exs file.

              config :dwolla, client_id: "your_client_id"
              """

      {client_id, client_secret} ->
        %{client_id: client_id, client_secret: client_secret}
    end
  end
  defp get_client_id, do: Application.get_env(:dwolla, :client_id) || :not_found

  defp get_client_secret, do: Application.get_env(:dwolla, :client_secret) || :not_found
end
