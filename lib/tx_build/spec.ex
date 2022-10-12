defmodule Stellar.TxBuild.Spec do
  @moduledoc """
  Defines contracts to build a Stellar transaction.
  """

  alias Stellar.TxBuild

  alias Stellar.TxBuild.{
    Account,
    AccountMerge,
    BaseFee,
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
    Payment,
    PathPaymentStrictSend,
    PathPaymentStrictReceive,
    SequenceNumber,
    SetOptions,
    Signature,
    TimeBounds,
    Preconditions
  }

  @type opts :: Keyword.t()
  @type account :: Account.t()
  @type sequence_number :: SequenceNumber.t()
  @type memo :: Memo.t()
  @type base_fee :: BaseFee.t()
  @type time_bounds :: TimeBounds.t()
  @type preconditions :: Preconditions.t()
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
  @type envelope :: String.t()
  @type tx_build :: {:ok, TxBuild.t()} | {:error, atom()}
  @type tx_envelope :: {:ok, envelope()} | {:error, atom()}
  @type hash :: {:ok, String.t()} | {:error, atom()}

  @callback new(account(), opts()) :: tx_build()
  @callback add_memo(tx_build(), memo()) :: tx_build()
  @callback set_time_bounds(tx_build(), time_bounds()) :: tx_build()
  @callback set_preconditions(tx_build(), preconditions()) :: tx_build()
  @callback set_base_fee(tx_build(), base_fee()) :: tx_build()
  @callback set_sequence_number(tx_build(), sequence_number()) :: tx_build()
  @callback add_operation(tx_build(), operation()) :: tx_build()
  @callback add_operations(tx_build(), operations()) :: tx_build()
  @callback sign(tx_build(), signatures()) :: tx_build()
  @callback build(tx_build()) :: tx_build()
  @callback envelope(tx_build()) :: tx_envelope()
  @callback sign_envelope(envelope(), signatures()) :: tx_envelope()
  @callback hash(tx_build()) :: hash()

  @optional_callbacks add_memo: 2,
                      set_base_fee: 2,
                      set_time_bounds: 2,
                      set_preconditions: 2,
                      set_sequence_number: 2
end
