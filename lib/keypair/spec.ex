defmodule Stellar.KeyPair.Spec do
  @moduledoc """
  Defines contracts to generate, validate and encode/decode Stellar KeyPairs.

  This `behaviour` allows you to use any crypto package of your choice.
  The default is Ed25519.
  """

  @type public_key :: String.t()
  @type secret_seed :: String.t()
  @type error :: {:error, atom()}
  @type validation :: :ok | error()

  @callback random() :: {public_key(), secret_seed()}

  @callback from_secret_seed(secret_seed()) :: {public_key(), secret_seed()}

  @callback raw_public_key(public_key()) :: binary()

  @callback raw_secret_seed(public_key()) :: binary()

  @callback validate_public_key(String.t()) :: validation()

  @callback validate_secret_seed(String.t()) :: validation()

  @callback sign(binary(), secret_seed()) :: binary() | error()
end
