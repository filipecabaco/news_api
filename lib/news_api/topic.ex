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

  def get(%NewsApi.User{id: id}) do
    token = Application.fetch_env!(:news_api, :news_api_token)
    topics = NewsApi.Repo.all(from(t in __MODULE__, where: t.user_id == ^id))

    topics
    |> Enum.map(fn %{topic: topic} ->
      {topic,
       "https://newsapi.org/v2/top-headlines?q=#{topic}&sortBy=publishedAt&apiKey=#{token}"}
    end)
    |> Enum.map(fn {topic, query} -> {topic, Req.get!(query)} end)
    |> Enum.map(fn {topic, response} ->
      {topic, Enum.map(response.body["articles"], & &1["title"])}
    end)
    |> Enum.into(%{})
  end
end
