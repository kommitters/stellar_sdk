defmodule Stellar.TxBuild.Resource do
  @moduledoc """
  Specifies the behaviour contract for the transaction resources.
  """

  @callback new(any(), any()) :: struct() | {:error, atom()}

  @callback to_xdr(struct()) :: struct()
end
