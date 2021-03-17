defmodule ClusterUser.Accounts.User.Actor do
  use GenServer

  def fetch_user(pid) do
    GenServer.call(pid, :fetch_user)
  end

  def start_link(%{id: id} = state) do
    GenServer.start_link(__MODULE__, state,
      name: {:via, Registry, {ClusterUser.Accounts.User.Registry, id}}
    )
  end

  def handle_call(:fetch_user, _from, state), do: {:reply, state, state}

  def init(state) do
    {:ok, state}
  end
end
