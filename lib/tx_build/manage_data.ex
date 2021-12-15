defmodule Stellar.TxBuild.ManageData do
  @moduledoc """
  Sets, modifies, or deletes a Data Entry (name/value pair).
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.OptionalAccount

  alias StellarBase.XDR.{
    DataValue,
    OperationBody,
    OperationType,
    Operations.ManageData,
    OptionalDataValue,
    String64
  }

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          entry_name: String.t(),
          entry_value: String.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:entry_name, :entry_value, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    entry_name = Keyword.get(args, :entry_name)
    entry_value = Keyword.get(args, :entry_value)
    source_account = Keyword.get(args, :source_account)

    with {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        entry_name: entry_name,
        entry_value: entry_value,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{entry_name: entry_name, entry_value: entry_value}) do
    entry_value = data_value_xdr(entry_value)
    op_type = OperationType.new(:MANAGE_DATA)

    entry_name
    |> String64.new()
    |> ManageData.new(entry_value)
    |> OperationBody.new(op_type)
  end

  @spec data_value_xdr(value :: any()) :: OptionalDataValue.t()
  defp data_value_xdr(nil), do: OptionalDataValue.new(nil)

  defp data_value_xdr(value) do
    value
    |> DataValue.new()
    |> OptionalDataValue.new()
  end
end
