use Mix.Config

config :stellar_sdk,
  http_client: Stellar.Horizon.HackneyMock,
  network: :test
