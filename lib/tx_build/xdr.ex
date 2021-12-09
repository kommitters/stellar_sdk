defmodule Stellar.TxBuild.XDR do
  @moduledoc """
  Defines the XDR construction callbacks for the transaction's components.
  """
  @type error :: {:error, atom()}

  @callback new(any(), any()) :: struct() | error()

  @callback to_xdr(struct()) :: struct()
end
