defmodule ClusterUser.ApplicationSupervisor do
  @moduledoc """
  You should use Horde when you want a global supervisor (or global registry, or some combination of the two)
  that supports automatic fail-over, dynamic cluster membership, and graceful node shutdown.

  Horde mirrors the API of Elixir’s Supervisor and Registry as much as possible,
  and in fact it runs its own Supervisor per node, distributing processes among the cluster’s nodes
  using a simple hash function (ala Swarm).

  While Swarm’s global process registry blurs the line between a registry and a supervisor
  (for example, using register_name/5, Swarm will start and restart a process for you,
  but not otherwise supervise your process), Horde maintains a strict separation of supervisor from registry.

  This is the biggest difference between Swarm and Horde and resolves some problems stemming from Swarm’s blurring
  of these concepts.

  Thus, Horde provides both Horde.Supervisor and Horde.Registry, and it’s up to you as developer
  to decide how you want to mix and match them, just like a regular supervisor / registry.
  This is a big advantage if you want to run a supervisor tree underneath Horde.Supervisor for example,
  and not just singular processes.

  Swarm’s use of distributed Erlang to determine which nodes are in the swarm is a limiting factor
  when wanting to implement graceful shutdown.
  This is solved in Horde by not relying on distributed Erlang in this way.
  Nodes still need to be connected with distributed Erlang,
  but Horde cluster membership is registered separately, enabling one to remove a node from the horde
  while leaving it connected to the Erlang cluster for a time.
  Processes will then be drained from the removed node and restarted on another node in the cluster.

  Horde is built on delta-CRDTs. CRDTs (conflict-free replicated data types)
  are guaranteed to converge (eventually, but Horde communicates aggressively to keep divergences to a minimum),
  which is a very handy property to have when building distributed systems.
  Being able to say with certainty that the distributed state will always converge does give some peace of mind.

  It is unlikely, but possible, that Horde.DynamicSupervisor will start the same process on two separate nodes.

  This can happen:

    * if using a custom distribution strategy, or
    * when a node dies and not all nodes have the same view of the cluster, or
    * if there is a network partition.

  Once a network partition has healed, Horde will automatically terminate any duplicate processes.
  When processes on two different nodes have claimed the same name, this will generate a conflict in Horde.Registry.
  The CRDT resolves the conflict and Horde.Registry sends an exit signal to the process that lost the conflict.
  This can be a common occurrence.

  """
  use Horde.DynamicSupervisor
  require Logger

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [%{}]}
    }
  end

  def start_link(_) do
    Horde.DynamicSupervisor.start_link(
      __MODULE__,
      [strategy: :one_for_one, members: :auto],
      name: __MODULE__
    )
  end

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end

  defp members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node ->
      Logger.debug("Supervisor Node #{inspect(Node.self())} joining with Node #{inspect(node)}")
      {__MODULE__, node}
    end)
  end
end
