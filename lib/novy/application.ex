defmodule Novy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NovyWeb.Telemetry,
      Novy.Repo,
      {DNSCluster, query: Application.get_env(:novy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Novy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Novy.Finch},
      # Start a worker by calling: Novy.Worker.start_link(arg)
      # {Novy.Worker, arg},
      # Start to serve requests, typically the last entry
      NovyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Novy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NovyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
