defmodule ClusterUser.Accounts do
  def add_user(user) do
    ClusterUser.Accounts.User.Actor.register_actor(user)
  end

  def fetch_user(id) do
    ClusterUser.Accounts.User.Actor.fetch_user(id)
  end
end
