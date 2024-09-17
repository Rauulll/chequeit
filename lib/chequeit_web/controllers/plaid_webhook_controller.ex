defmodule ChequeitWeb.PlaidWebhookController do
  use ChequeitWeb, :controller

  alias ChequeitWeb.PlaidController
  alias ChequeitWeb.Api.ApiController

  def index(conn, _) do
    jwt =
      conn
      |> get_req_header("plaid-verification")
      |> List.first()

    raw_body = conn.assigns[:raw_body]

    config = ApiController.plaid_config()

    case Plaid.Webhooks.verify_and_construct(jwt, raw_body, config) do
      {:ok, body} ->
        handle_webhook(body, conn)
        json(conn, %{"status" => "ok"})

      {:error, _} ->
        conn
        |> put_status(400)
        |> json(%{"status" => "error"})
    end
  end

  defp handle_webhook(%{
         webhook_type: "LINK",
         webhook_code: "SESSION_FINISHED",
         status: "SUCCESS",
         public_tokens: public_token
       }, conn) do
    PlaidController.exchange_token(public_token, conn)
  end

  defp handle_webhook(%{
          webhook_type: "LINK",
          webhook_code: "SESSION_FINISHED",
          status: "EXITED",
       }, conn) do
    conn
    |> put_status(500)
    |> halt()
  end
end
