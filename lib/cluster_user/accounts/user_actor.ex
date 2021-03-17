defmodule ClusterUser.Accounts.User.Actor do
  use GenServer

  def fetch_user(pid) do
    GenServer.call(pid, :fetch_user)
  end

  def register_actor(%{id: id} = state) do
    {:ok, pid} =
      Swarm.register_name(id, ClusterUser.Accounts.User.DynamicSupervisor, :register, [state])

    Swarm.join(:users, pid)

    pid
  end

  def start_link(%{id: id} = _state) do
    GenServer.start_link(__MODULE__, [id])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:fetch_user, _from, state), do: {:reply, state, state}

  # Change the handling of :begin_handoff
  # This is triggered whenever a registered process is to be killed.
  def handle_call({:swarm, :begin_handoff}, _from, current_state) do
    {:reply, {:resume, current_state, current_state}}
  end
end
