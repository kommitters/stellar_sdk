use Mix.Config

config :stellar_sdk,
  http_client_impl: Stellar.Horizon.Client.CannedClientImpl,
  http_client: Stellar.Horizon.Client.CannedHTTPClient,
  network: :test
