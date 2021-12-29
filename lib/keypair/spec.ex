defmodule Stellar.KeyPair.Spec do
  @moduledoc """
  Specifies the behaviour for KeyPair generators.
  This Library allows you to use any crypto package of your choice.
  The default is Ed25519.
  """

  @type public_key :: String.t()
  @type secret_seed :: String.t()
  @type error :: {:error, atom()}
  @type validation :: :ok | error()

  @callback random() :: {public_key(), secret_seed()}

  @callback from_secret(secret_seed()) :: {public_key(), secret_seed()}

  @callback raw_ed25519_public_key(public_key()) :: binary()

  @callback raw_ed25519_secret(public_key()) :: binary()

  @callback sign(binary(), secret_seed()) :: binary() | error()

  @callback validate_ed25519_public_key(String.t()) :: validation()

  @callback validate_ed25519_secret_seed(String.t()) :: validation()
end
