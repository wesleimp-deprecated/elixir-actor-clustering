defmodule ClusterUser.Accounts do
  def add_user(user) do
    ClusterUser.Accounts.User.DynamicSupervisor.register(user)
  end

  def fetch_user(id) do
    {:ok, pid} = ClusterUser.Accounts.User.Registry.lookup_user(id)
    ClusterUser.Accounts.User.Actor.fetch_user(pid)
  end
end
