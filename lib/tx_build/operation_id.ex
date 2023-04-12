defmodule Stellar.TxBuild.OperationID do
  @moduledoc """
  `OperationID` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_account_id: 1,
      validate_sequence_number: 1
    ]

  alias Stellar.TxBuild.{AccountID, SequenceNumber}
  alias StellarBase.XDR.{OperationID, UInt32}

  @type t :: %__MODULE__{
          source_account: AccountID.t(),
          sequence_number: SequenceNumber.t(),
          op_num: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:source_account, :sequence_number, :op_num]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    source_account = Keyword.get(args, :source_account)
    sequence_number = Keyword.get(args, :sequence_number)
    op_num = Keyword.get(args, :op_num)

    with {:ok, source_account} <- validate_account_id({:source_account, source_account}),
         {:ok, sequence_number} <- validate_sequence_number({:sequence_number, sequence_number}),
         {:ok, op_num} <- validate_pos_integer({:op_num, op_num}) do
      %__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        op_num: op_num
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_id}

  @impl true
  def to_xdr(%__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        op_num: op_num
      }) do
    source_account = AccountID.to_xdr(source_account)
    sequence_number = SequenceNumber.to_xdr(sequence_number)
    op_num = UInt32.new(op_num)

    OperationID.new(source_account, sequence_number, op_num)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_operation_id}
end
