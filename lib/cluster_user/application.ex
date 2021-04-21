defmodule ClusterUser.Application do
  @moduledoc false

  use Application

  @user_supervisor [
    ClusterUser.Accounts.User.DynamicSupervisor
  ]
  @cluster_supervisor [
    ClusterUser.ApplicationRegistry.child_spec(),
    ClusterUser.ApplicationSupervisor.child_spec()
  ]
  @phoenix [
    ClusterUserWeb.Telemetry,
    {Phoenix.PubSub, name: ClusterUser.PubSub},
    ClusterUserWeb.Endpoint
  ]

  @topologies Application.get_env(:libcluster, :topologies)

  def start(_type, _args) do
    children =
      @phoenix ++
        [
          {Cluster.Supervisor, [@topologies, [name: ClusterUser.ClusterSupervisor]]}
        ] ++ @cluster_supervisor ++ @user_supervisor

    opts = [strategy: :one_for_one, name: ClusterUser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ClusterUserWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
