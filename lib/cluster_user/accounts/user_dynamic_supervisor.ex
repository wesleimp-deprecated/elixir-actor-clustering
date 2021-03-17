defmodule ClusterUser.Accounts.User.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def register(user) do
    child_spec = %{
      id: ClusterUser.Accounts.User.Actor,
      start: {ClusterUser.Accounts.User.Actor, :start_link, [user]},
      restart: :transient
    }

    case DynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:ok, pid} -> {:ok, pid}
    end
  end
end
