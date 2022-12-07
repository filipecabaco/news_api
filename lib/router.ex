defmodule NewsApi.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/" do
    handle_bearer_token(conn, &handle_fetch_user/2)
  end

  put "/:topic" do
    handle_bearer_token(conn, &handle_add_topic/2)
  end

  delete "/:topic" do
    handle_bearer_token(conn, &handle_delete_topic/2)
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

  defp handle_fetch_user(conn, token) do
    user = NewsApi.User.get(token)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(user))
  end

  defp handle_add_topic(conn, token) do
    %{"topic" => topic} = conn.params
    user = NewsApi.User.get(token)
    topic = NewsApi.Topic.new(user, topic)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(topic))
  end

  defp handle_delete_topic(conn, token) do
    %{"topic" => topic} = conn.params
    user = NewsApi.User.get(token)
    NewsApi.Topic.delete(user, topic)
    send_resp(conn, 204, "")
  end

  defp handle_bearer_token(conn, on_success) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> on_success.(conn, token)
      _ -> send_resp(conn, 400, "not found")
    end
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{reason: %Ecto.InvalidChangesetError{changeset: changeset}}) do
    msg = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
    send_resp(conn, 400, Jason.encode!(msg))
  end

  def handle_errors(conn, _) do
    send_resp(conn, conn.status, "internal server error")
  end
end
