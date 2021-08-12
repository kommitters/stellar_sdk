use Mix.Config

config :stellar_sdk,
  http_client: StellarSDK.Horizon.HackneyMock,
  network: :test
