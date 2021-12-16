defmodule Stellar.TxBuild.BumpSequence do
  @moduledoc """
  Bumps sequence number.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.OptionalAccount
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.BumpSequence, SequenceNumber}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{bump_to: pos_integer(), source_account: OptionalAccount.t()}

  defstruct [:bump_to, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    bump_to = Keyword.get(args, :bump_to)
    source_account = Keyword.get(args, :source_account)

    with {:ok, bump_to} <- validate_pos_integer({:bump_to, bump_to}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{bump_to: bump_to, source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{bump_to: bump_to}) do
    op_type = OperationType.new(:BUMP_SEQUENCE)

    bump_to
    |> SequenceNumber.new()
    |> BumpSequence.new()
    |> OperationBody.new(op_type)
  end
end
