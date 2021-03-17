defmodule ClusterUserWeb.PageController do
  use ClusterUserWeb, :controller

  def index(conn, %{"id" => id}) do
    user = ClusterUser.Accounts.fetch_user(id)

    conn
    |> put_status(:ok)
    |> json(%{
      user: user,
      node: node()
    })
  end
end
