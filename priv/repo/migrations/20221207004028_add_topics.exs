defmodule NewsApi.Repo.Migrations.AddTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :user_id, references(:users)
      add :topic, :string
    end

    create unique_index(:topics, [:topic, :user_id])
  end
end
