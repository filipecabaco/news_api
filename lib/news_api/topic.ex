defmodule NewsApi.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  @derive {Jason.Encoder, only: [:topic]}

  schema "topics" do
    field(:topic, :string)
    belongs_to(:user, NewsApi.User)
  end

  def new(%NewsApi.User{} = user, topic) do
    params = %{topic: topic}

    changeset =
      %__MODULE__{}
      |> cast(params, [:topic])
      |> put_assoc(:user, user)
      |> unique_constraint([:topic, :user_id])

    NewsApi.Repo.insert!(changeset)
  end

  def delete(%NewsApi.User{id: id}, topic) do
    topic =
      NewsApi.Repo.one!(from(t in __MODULE__, where: t.topic == ^topic, where: t.user_id == ^id))

    NewsApi.Repo.delete!(topic)
  end
end
