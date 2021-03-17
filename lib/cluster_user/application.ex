defmodule ClusterUser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @user_supervisor [
    ClusterUser.Accounts.User.DynamicSupervisor
  ]
  @phoenix [
    ClusterUserWeb.Telemetry,
    {Phoenix.PubSub, name: ClusterUser.PubSub},
    ClusterUserWeb.Endpoint
  ]

  @topologies [
    kubernetes: [
      strategy: Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        service: "cluster-user",
        kubernetes_node_basename: "cluster-user",
        kubernetes_selector: "app=cluster-user",
        kubernetes_namespace: "local",
        polling_interval: 10_000
      ]
    ]
  ]

  def start(_type, _args) do
    children =
      @phoenix ++
        [
          {Cluster.Supervisor, [@topologies, [name: ClusterUser.ClusterSupervisor]]}
        ] ++ @user_supervisor

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusterUser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ClusterUserWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
