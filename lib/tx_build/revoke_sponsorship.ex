defmodule Stellar.TxBuild.RevokeSponsorship do
  @moduledoc """
  Revoke sponsorship of a ledger entry.
  """
  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias StellarBase.XDR.{
    OperationBody,
    OperationType,
    Operations.RevokeSponsorship,
    RevokeSponsorshipType
  }

  alias Stellar.TxBuild.{LedgerKey, OptionalAccount, RevokeSponsorshipSigner}

  @behaviour Stellar.TxBuild.XDR

  @type sponsorship_type :: :ledger_entry | :signer
  @type sponsorship :: LedgerKey.t() | RevokeSponsorshipSigner.t()
  @type ledger_entry :: {atom(), Keyword.t()}
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          sponsorship: sponsorship(),
          type: sponsorship_type(),
          source_account: OptionalAccount.t()
        }

  defstruct [:sponsorship, :type, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new([{key, ledger_entry}] = args, _opts)
      when key in ~w(account claimable_balance data liquidity_pool offer trustline)a do
    source_account = Keyword.get(args, :source_account)

    with {:ok, ledger_key} <- validate_ledger_key({key, ledger_entry}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        sponsorship: ledger_key,
        type: :ledger_entry,
        source_account: source_account
      }
    end
  end

  def new([{:signer, signer}] = args, _opts) do
    source_account = Keyword.get(args, :source_account)

    with {:ok, sponsorship_signer} <- validate_signer(signer),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{sponsorship: sponsorship_signer, type: :signer, source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sponsorship}

  @impl true
  def to_xdr(%__MODULE__{type: :ledger_entry, sponsorship: %LedgerKey{} = sponsorship}) do
    op_type = OperationType.new(:REVOKE_SPONSORSHIP)
    revoke_sponsorship_type = RevokeSponsorshipType.new(:REVOKE_SPONSORSHIP_LEDGER_ENTRY)

    sponsorship
    |> LedgerKey.to_xdr()
    |> RevokeSponsorship.new(revoke_sponsorship_type)
    |> OperationBody.new(op_type)
  end

  @impl true
  def to_xdr(%__MODULE__{type: :signer, sponsorship: %RevokeSponsorshipSigner{} = sponsorship}) do
    op_type = OperationType.new(:REVOKE_SPONSORSHIP)
    revoke_sponsorship_type = RevokeSponsorshipType.new(:REVOKE_SPONSORSHIP_SIGNER)

    sponsorship
    |> RevokeSponsorshipSigner.to_xdr()
    |> RevokeSponsorship.new(revoke_sponsorship_type)
    |> OperationBody.new(op_type)
  end

  @spec validate_ledger_key(ledger_entry :: ledger_entry()) :: validation()
  defp validate_ledger_key(ledger_entry) do
    case LedgerKey.new(ledger_entry) do
      %LedgerKey{} = ledger_key -> {:ok, ledger_key}
      _error -> {:error, :invalid_ledger_key}
    end
  end

  @spec validate_signer(signer :: Keyword.t()) :: validation()
  defp validate_signer(signer) do
    case RevokeSponsorshipSigner.new(signer) do
      %RevokeSponsorshipSigner{} = sponsorship_signer -> {:ok, sponsorship_signer}
      _error -> {:error, :invalid_signer}
    end
  end
end
