defmodule NewsApi.Application do
  use Application
  require Logger

  def start(_, _) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: NewsApi.Router, options: [port: 4000]},
      NewsApi.Repo
    ]

    Logger.info("Server started at port 4000")
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
