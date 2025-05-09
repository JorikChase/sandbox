defmodule Sandbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SandboxWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:sandbox, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sandbox.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sandbox.Finch},
      # Start a worker by calling: Sandbox.Worker.start_link(arg)
      # {Sandbox.Worker, arg},
      # Start to serve requests, typically the last entry
      SandboxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sandbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SandboxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
