defmodule Stellar.TxBuild.SetTrustlineFlags do
  @moduledoc """
  Allows an issuing account to configure various authorization
  and trustline flags for all trustlines to an asset.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_account_id: 1,
      validate_asset: 1,
      validate_optional_account: 1
    ]

  alias Stellar.TxBuild.{AccountID, Asset, TrustlineFlags, OptionalAccount}

  alias StellarBase.XDR.{OperationBody, OperationType, Operations.SetTrustLineFlags}

  @behaviour Stellar.TxBuild.XDR

  @type error :: Keyword.t() | atom()
  @type validation :: {:ok, any()} | {:error, error()}
  @type t :: %__MODULE__{
          trustor: AccountID.t(),
          asset: Asset.t(),
          clear_flags: TrustlineFlags.t(),
          set_flags: TrustlineFlags.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:trustor, :asset, :clear_flags, :set_flags, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    trustor = Keyword.get(args, :trustor)
    asset = Keyword.get(args, :asset)
    clear_flags = Keyword.get(args, :clear_flags)
    set_flags = Keyword.get(args, :set_flags)
    source_account = Keyword.get(args, :source_account)

    with {:ok, trustor} <- validate_account_id({:trustor, trustor}),
         {:ok, asset} <- validate_asset({:asset, asset}),
         {:ok, clear_flags} <- validate_trustline_flags({:clear_flags, clear_flags}),
         {:ok, set_flags} <- validate_trustline_flags({:set_flags, set_flags}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        trustor: trustor,
        asset: asset,
        clear_flags: clear_flags,
        set_flags: set_flags,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        trustor: trustor,
        asset: asset,
        clear_flags: clear_flags,
        set_flags: set_flags
      }) do
    op_type = OperationType.new(:SET_TRUST_LINE_FLAGS)

    trustor = AccountID.to_xdr(trustor)
    asset = Asset.to_xdr(asset)
    clear_flags = TrustlineFlags.to_xdr(clear_flags)
    set_flags = TrustlineFlags.to_xdr(set_flags)

    trustor
    |> SetTrustLineFlags.new(
      asset,
      clear_flags,
      set_flags
    )
    |> OperationBody.new(op_type)
  end

  @spec validate_trustline_flags(number :: number()) :: validation()
  defp validate_trustline_flags({_field, nil}), do: {:ok, TrustlineFlags.new()}

  defp validate_trustline_flags({field, value}) do
    case TrustlineFlags.new(value) do
      %TrustlineFlags{} -> {:ok, TrustlineFlags.new(value)}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end
end
