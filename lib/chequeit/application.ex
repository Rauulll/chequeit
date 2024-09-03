defmodule Chequeit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChequeitWeb.Telemetry,
      Chequeit.Repo,
      {DNSCluster, query: Application.get_env(:chequeit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Chequeit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Chequeit.Finch},
      # Start a worker by calling: Chequeit.Worker.start_link(arg)
      # {Chequeit.Worker, arg},
      # Start to serve requests, typically the last entry
      ChequeitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chequeit.Supervisor]

    Logger.add_handlers(:chequeit)

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChequeitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
