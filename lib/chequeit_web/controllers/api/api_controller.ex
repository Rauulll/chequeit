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
end
