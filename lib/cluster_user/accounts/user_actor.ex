defmodule ClusterUser.Accounts.User.Actor do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(%{id: id} = state) do
    GenServer.start_link(__MODULE__, [state], name: via_tuple(id))
  end

  def fetch_user(id) do
    GenServer.call(via_tuple(id), :fetch_user)
  end

  def register_actor(state) do
    {:ok, pid} = ClusterUser.Accounts.User.DynamicSupervisor.register(state)
    pid
  end

  def handle_call(:fetch_user, _from, state), do: {:reply, state, state}

  def via_tuple(id), do: {:via, Horde.Registry, {ClusterUser.ApplicationRegistry, id}}
end
