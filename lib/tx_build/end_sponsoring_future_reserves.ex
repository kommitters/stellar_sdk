defmodule Stellar.TxBuild.EndSponsoringFutureReserves do
  @moduledoc """
  Ends a sponsorship.
  """
  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.OptionalAccount
  alias StellarBase.XDR.{OperationBody, OperationType, Void}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{source_account: OptionalAccount.t()}

  defstruct [:source_account]

  @impl true
  def new(args \\ [], opts \\ [])

  def new(args, _opts) when is_list(args) do
    source_account = Keyword.get(args, :source_account)

    with {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{}) do
    op_type = OperationType.new(:END_SPONSORING_FUTURE_RESERVES)
    OperationBody.new(Void.new(), op_type)
  end
end
