defmodule Novy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Novy.Repo,
      {DNSCluster, query: Application.get_env(:novy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Novy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Novy.Finch}
      # Start a worker by calling: Novy.Worker.start_link(arg)
      # {Novy.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Novy.Supervisor)
  end
end
