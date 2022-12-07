defmodule NewsApi.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  get "/" do
    raise "Potato"
    send_resp(conn, 200, "howdy")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, _) do
    send_resp(conn, conn.status, "internal server error")
  end
end
