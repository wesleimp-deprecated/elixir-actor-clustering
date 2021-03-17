defmodule ClusterUser.Accounts do
  def add_user(user) do
    ClusterUser.Accounts.User.Actor.register_actor(user)
  end

  def fetch_user(id) do
    Swarm.whereis_name(id)
    |> ClusterUser.Accounts.User.Actor.fetch_user()
  end
end
