defmodule Iori.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IoriWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:iori, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Iori.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Iori.Finch},
      # Start a worker by calling: Iori.Worker.start_link(arg)
      # {Iori.Worker, arg},
      # Start to serve requests, typically the last entry
      IoriWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Iori.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IoriWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
