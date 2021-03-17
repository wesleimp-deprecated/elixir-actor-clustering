defmodule ClusterUser.Accounts.User.Registry do
  def lookup_user(user_id) do
    case Swarm.whereis_name(user_id) do
      :undefined -> {:error, :not_found}
      pid -> {:ok, pid}
    end
  end
end
