defmodule NewsApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:name, :topics]}

  schema "users" do
    field(:name, :string)
    field(:token, :string)
    has_many(:topics, NewsApi.Topic)
  end

  def new(name, token) do
    params = %{name: name, token: Base.encode64(token)}
    changeset = cast(%__MODULE__{}, params, [:name, :token])
    NewsApi.Repo.insert(changeset)
  end

  def get(token) do
    __MODULE__
    |> NewsApi.Repo.get_by!(token: Base.encode64(token))
    |> NewsApi.Repo.preload(:topics)
  end
end
