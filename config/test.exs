use Mix.Config

config :stellar_sdk,
  network: :test,
  http_client_impl: Stellar.Horizon.Client.CannedClientImpl,
  http_client: Stellar.Horizon.Client.CannedHTTPClient,
  keypair_impl: Stellar.KeyPair.CannedKeyPairImpl
