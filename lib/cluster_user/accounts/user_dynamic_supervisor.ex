defmodule ClusterUser.Accounts.User.DynamicSupervisor do
  use Horde.DynamicSupervisor
  require Logger

  alias Horde.DynamicSupervisor, as: HordeDynamicSupervisor

  def init(_) do
    HordeDynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(opts) do
    HordeDynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def register(user) do
    child_spec = %{
      id: ClusterUser.Accounts.User.Actor,
      start: {ClusterUser.Accounts.User.Actor, :start_link, [user]},
      restart: :transient
    }

    case HordeDynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:ok, pid} -> {:ok, pid}
    end
  end

  def via_tuple(id), do: {:via, Horde.Registry, {ClusterUser.ApplicationRegistry, id}}
end
