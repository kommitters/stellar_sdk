defmodule Stellar.Horizon.Operation do
  @moduledoc """
  Represents a `Operation` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.{Mapping, Transaction}

  alias Stellar.Horizon.Operation.{
    AccountMerge,
    AllowTrust,
    BeginSponsoringFutureReserves,
    ExtendFootprintTTL,
    BumpSequence,
    ChangeTrust,
    CreateAccount,
    CreateClaimableBalance,
    ClaimClaimableBalance,
    CreatePassiveSellOffer,
    EndSponsoringFutureReserves,
    InvokeHostFunction,
    LiquidityPoolDeposit,
    LiquidityPoolWithdraw,
    ManageBuyOffer,
    ManageSellOffer,
    ManageData,
    PathPaymentStrictReceive,
    PathPaymentStrictSend,
    Payment,
    RevokeSponsorship,
    SetOptions
  }

  @type body ::
          AccountMerge.t()
          | AllowTrust.t()
          | BeginSponsoringFutureReserves.t()
          | BumpSequence.t()
          | ChangeTrust.t()
          | CreateAccount.t()
          | CreateClaimableBalance.t()
          | ClaimClaimableBalance.t()
          | CreatePassiveSellOffer.t()
          | EndSponsoringFutureReserves.t()
          | LiquidityPoolDeposit.t()
          | LiquidityPoolWithdraw.t()
          | ManageBuyOffer.t()
          | ManageSellOffer.t()
          | ManageData.t()
          | PathPaymentStrictReceive.t()
          | PathPaymentStrictSend.t()
          | Payment.t()
          | RevokeSponsorship.t()
          | SetOptions.t()

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          source_account: String.t(),
          type_i: non_neg_integer(),
          type: String.t(),
          transaction_hash: String.t(),
          transaction_successful: boolean(),
          body: body(),
          transaction: Transaction.t() | nil,
          created_at: DateTime.t()
        }

  defstruct [
    :id,
    :paging_token,
    :source_account,
    :type,
    :type_i,
    :transaction_hash,
    :transaction_successful,
    :body,
    :transaction,
    :created_at
  ]

  @mapping [
    id: :integer,
    type_i: :integer,
    transaction: {:struct, Transaction},
    created_at: :date_time
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    mapping =
      attrs
      |> Map.get(:type)
      |> operation_type_mapping()

    attrs
    |> operation_attrs()
    |> (&Mapping.build(%__MODULE__{}, &1)).()
    |> Mapping.parse(mapping)
  end

  @spec operation_attrs(attrs :: map()) :: map()
  defp operation_attrs(attrs) do
    body_attrs =
      %__MODULE__{}
      |> Map.from_struct()
      |> Map.keys()
      |> (&Map.drop(attrs, &1 ++ [:_links])).()

    Map.put(attrs, :body, body_attrs)
  end

  @spec operation_type_mapping(type :: any()) :: Keyword.t()
  defp operation_type_mapping(nil), do: @mapping
  defp operation_type_mapping("restore_footprint"), do: @mapping

  defp operation_type_mapping(type),
    do: Keyword.merge(@mapping, body: {:struct, operation_type(type)})

  @spec operation_type(type :: String.t()) :: module()
  defp operation_type("create_account"), do: CreateAccount
  defp operation_type("payment"), do: Payment
  defp operation_type("path_payment_strict_receive"), do: PathPaymentStrictReceive
  defp operation_type("path_payment_strict_send"), do: PathPaymentStrictSend
  defp operation_type("manage_sell_offer"), do: ManageSellOffer
  defp operation_type("manage_buy_offer"), do: ManageBuyOffer
  defp operation_type("create_passive_sell_offer"), do: CreatePassiveSellOffer
  defp operation_type("set_options"), do: SetOptions
  defp operation_type("change_trust"), do: ChangeTrust
  defp operation_type("allow_trust"), do: AllowTrust
  defp operation_type("account_merge"), do: AccountMerge
  defp operation_type("manage_data"), do: ManageData
  defp operation_type("bump_sequence"), do: BumpSequence
  defp operation_type("create_claimable_balance"), do: CreateClaimableBalance
  defp operation_type("claim_claimable_balance"), do: ClaimClaimableBalance
  defp operation_type("begin_sponsoring_future_reserves"), do: BeginSponsoringFutureReserves
  defp operation_type("end_sponsoring_future_reserves"), do: EndSponsoringFutureReserves
  defp operation_type("revoke_sponsorship"), do: RevokeSponsorship
  defp operation_type("liquidity_pool_deposit"), do: LiquidityPoolDeposit
  defp operation_type("liquidity_pool_withdraw"), do: LiquidityPoolWithdraw
  defp operation_type("invoke_host_function"), do: InvokeHostFunction
  defp operation_type("extend_footprint_ttl"), do: ExtendFootprintTTL
end
