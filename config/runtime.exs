import Config

config :news_api, news_api_token: System.fetch_env!("NEWS_API_TOKEN")
