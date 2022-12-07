import Config
config :news_api, ecto_repos: [NewsApi.Repo]

config :news_api, NewsApi.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
