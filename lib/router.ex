defmodule NewsApi.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "howdy")
  end

  post "/" do
    %{"name" => name} = conn.body_params
    token = Ecto.UUID.generate()
    {:ok, _} = NewsApi.User.new(name, token)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{token: token}))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, _) do
    send_resp(conn, conn.status, "internal server error")
  end
end
