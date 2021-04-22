defmodule ClusterUser.ApplicationRegistry do
  use Horde.Registry
  require Logger

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [%{}]}
    }
  end

  def start_link(_) do
    Horde.Registry.start_link(__MODULE__, [keys: :unique, members: :auto], name: __MODULE__)
  end

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.Registry.init()
  end

  defp members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node ->
      Logger.debug("Registry Node #{inspect(Node.self())} joining with Node #{inspect(node)}")
      {__MODULE__, node}
    end)
  end
end
