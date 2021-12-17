defmodule Stellar.TxBuild.BeginSponsoringFutureReserves do
  @moduledoc """
  Initiates a sponsorship.
  There must be a corresponding EndSponsoringFutureReserves operation in the same transaction.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{AccountID, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.BeginSponsoringFutureReserves}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          sponsored_id: AccountID.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:sponsored_id, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    sponsored_id = Keyword.get(args, :sponsored_id)
    source_account = Keyword.get(args, :source_account)

    with {:ok, sponsored_id} <- validate_account_id({:sponsored_id, sponsored_id}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{sponsored_id: sponsored_id, source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{sponsored_id: sponsored_id}) do
    op_type = OperationType.new(:BEGIN_SPONSORING_FUTURE_RESERVES)

    sponsored_id
    |> AccountID.to_xdr()
    |> BeginSponsoringFutureReserves.new()
    |> OperationBody.new(op_type)
  end
end
