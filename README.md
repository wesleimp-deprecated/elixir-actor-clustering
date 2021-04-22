# ClusterUser

To test Application:

  * Install dependencies with `mix deps.get`
  * Start one Phoenix endpoint node with `PORT=4000 iex --name a@127.0.0.1 -S mix phx.server`
  * Add User `ClusterUser.Accounts.add_user(%{id: "some_user"})`
    
    Now you can visit [`localhost:4000/test_user`](http://localhost:4000/test_user) from your browser.
    
    You see the response like `{"node":"a@127.0.0.1","user":[{"id":"test_user"}]}`
  * Now and other Terminal screen start another Phoenix endpoint node with `PORT=4444 iex --name b@127.0.0.1 -S mix phx.server`
    
    you can visit [`localhost:4444/test_user`](http://localhost:4000/test_user) from your browser.
    
    You see the response like `{"node":"b@127.0.0.1","user":[{"id":"test_user"}]}`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
