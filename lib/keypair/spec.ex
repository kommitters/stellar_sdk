defmodule Stellar.KeyPair.Spec do
  @moduledoc """
  Specifies the behaviour for KeyPair generators.
  This Library allows you to use any crypto package of your choice. The default is Ed25519.
  """
  @type error :: {:error, atom()}

  @callback random() :: {String.t(), String.t()}

  @callback from_secret(String.t()) :: {String.t(), String.t()}

  @callback raw_ed25519_public_key(String.t()) :: binary()

  @callback raw_ed25519_secret(String.t()) :: binary()

  @callback sign(binary(), String.t()) :: binary() | error()

  @callback validate_ed25519_public_key(String.t()) :: :ok | error()

  @callback validate_ed25519_secret_seed(String.t()) :: :ok | error()
end
