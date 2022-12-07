defmodule NewsApi.Topic do
  use Ecto.Schema
  import Ecto.Changeset
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
end
