defmodule Stellar.TxBuild.XDR do
  @moduledoc """
  Defines the XDR construction callbacks for the transaction's components.
  """

  @callback new(any(), any()) :: struct() | {:error, atom()}

  @callback to_xdr(struct()) :: struct()
end
