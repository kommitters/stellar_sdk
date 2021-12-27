defmodule Stellar.TxBuild.Spec do
  @moduledoc """
  Defines contracts to build a Stellar transaction.
  """

  alias Stellar.TxBuild.{Account, Memo, Operation, Signature, TimeBounds}

  @type opts :: Keyword.t()
  @type tx :: struct()
  @type account :: Account.t()
  @type memo :: Memo.t()
  @type time_bounds :: TimeBounds.t()
  @type signatures :: Signature.t() | list(Signature.t())
  @type operations :: Operation.t() | list(Operation.t())
  @type tx_envelope :: String.t()

  @callback new(account(), opts()) :: tx()
  @callback add_memo(tx(), memo()) :: tx()
  @callback set_timeout(tx(), time_bounds()) :: tx()
  @callback add_operation(tx(), operations()) :: tx()
  @callback sign(tx(), signatures()) :: tx()
  @callback build(tx()) :: tx()
  @callback envelope(tx()) :: tx_envelope()
end
