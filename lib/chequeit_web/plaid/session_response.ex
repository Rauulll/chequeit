defmodule ChequeitWeb.Plaid.SessionResponse do
  require Logger

  alias Plaid.Castable

  @moduledoc """
    [Plaid webhooks SESSION: SESSION_FINISHED schema](https://plaid.com/docs/api/link/#session_finished)
    """

  @behaviour Castable

  @type t :: %__MODULE__{
          expiration: String.t(),
          hosted_link_url: String.t(),
          link_token: String.t(),
          request_id: String.t()
        }

  defstruct [:expiration, :hosted_link_url, :link_token, :request_id]

  @impl true
  def cast(generic_map) do
    %__MODULE__{
      expiration: generic_map["expiration"],
      hosted_link_url: generic_map["hosted_link_url"],
      link_token: generic_map["link_token"],
      request_id: generic_map["request_id"]
    }
  end
end
