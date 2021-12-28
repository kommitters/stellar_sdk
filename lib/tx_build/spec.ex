defmodule Stellar.TxBuild.Spec do
  @moduledoc """
  Defines contracts to build a Stellar transaction.
  """

  alias Stellar.TxBuild.{
    Account,
    AccountMerge,
    BumpSequence,
    BeginSponsoringFutureReserves,
    ChangeTrust,
    Clawback,
    ClawbackClaimableBalance,
    CreateAccount,
    CreatePassiveSellOffer,
    EndSponsoringFutureReserves,
    ManageData,
    ManageSellOffer,
    ManageBuyOffer,
    Memo,
    Operation,
    Payment,
    PathPaymentStrictSend,
    PathPaymentStrictReceive,
    SetOptions,
    Signature,
    TimeBounds
  }

  @type opts :: Keyword.t()
  @type tx :: struct()
  @type account :: Account.t()
  @type memo :: Memo.t()
  @type time_bounds :: TimeBounds.t()
  @type signatures :: Signature.t() | list(Signature.t())
  @type operation ::
          AccountMerge.t()
          | BumpSequence.t()
          | BeginSponsoringFutureReserves.t()
          | ChangeTrust.t()
          | Clawback.t()
          | ClawbackClaimableBalance.t()
          | CreateAccount.t()
          | CreatePassiveSellOffer.t()
          | EndSponsoringFutureReserves.t()
          | ManageData.t()
          | ManageSellOffer.t()
          | ManageBuyOffer.t()
          | Payment.t()
          | PathPaymentStrictSend.t()
          | PathPaymentStrictReceive.t()
          | SetOptions.t()
  @type operations :: list(operation())
  @type tx_envelope :: String.t()

  @callback new(account(), opts()) :: tx()
  @callback add_memo(tx(), memo()) :: tx()
  @callback set_timeout(tx(), time_bounds()) :: tx()
  @callback add_operation(tx(), operation()) :: tx()
  @callback add_operations(tx(), operations()) :: tx()
  @callback sign(tx(), signatures()) :: tx()
  @callback build(tx()) :: tx()
  @callback envelope(tx()) :: tx_envelope()
end
