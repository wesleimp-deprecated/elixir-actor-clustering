defmodule ClusterUser.Accounts.User.Registry do
  def child_spec do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__,
      partitions: System.schedulers_online()
    )
  end

  def lookup_user(user_id) do
    case Registry.lookup(__MODULE__, user_id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end
end
