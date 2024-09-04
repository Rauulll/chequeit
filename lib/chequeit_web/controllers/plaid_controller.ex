defmodule ChequeitWeb.PlaidController do
  use ChequeitWeb, :controller

  import Plaid

  alias Plaid.Item
  alias Plaid.Sandbox
  alias Plaid.LinkToken
  alias ChequeitWeb.Api.ApiController

  def index(conn, _params) do
    user = get_session(conn, :user)

    create_token =
      LinkToken.create(
        %{
          client_name: user.name,
          language: "en",
          country_codes: ["US"],
          user: %{
            client_user_id: user.id,
            email_address: user.email
          },
          products: ["auth"]
        }, ApiController.plaid_config
      )
    create_plaid_link(create_token, conn)
  end

  def create_plaid_link({:ok, %LinkToken.CreateResponse{link_token: _link_token}}, conn) do
    {:ok, %Plaid.Sandbox.CreatePublicTokenResponse{public_token: public_token}} = Sandbox.create_public_token("ins_1", ["auth"], ApiController.plaid_config)

    exchange_token =
      Item.exchange_public_token(public_token, ApiController.plaid_config)

    handle_exchange_token(exchange_token, conn)
    end

  def create_plaid_link({:error, %Plaid.Error{error_code: error}}, conn) do
    render(conn, error: error, layout: false)
  end

  def handle_exchange_token({:ok, %Plaid.Item.ExchangePublicTokenResponse{access_token: access_token, item_id: item_id}}, conn) do
    conn
    |> assign(:access_toker, access_token)
    |> assign(:item_id, item_id)
    |> render(layout: false)
  end
end
