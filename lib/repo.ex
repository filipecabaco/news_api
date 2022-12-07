defmodule NewsApi.Repo do
  use Ecto.Repo, otp_app: :news_api, adapter: Ecto.Adapters.Postgres
end
