defmodule Stellar.TxBuild.BumpFootprintExpiration do
  @moduledoc """
  `BumpFootprintExpiration` struct definition.
  """
  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.OptionalAccount

  alias StellarBase.XDR.{
    ExtensionPoint,
    OperationBody,
    OperationType,
    Operations.BumpFootprintExpiration,
    UInt32,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type ledgers_to_expire :: integer()

  @type t :: %__MODULE__{
          ledgers_to_expire: ledgers_to_expire(),
          source_account: OptionalAccount.t()
        }

  defstruct [:ledgers_to_expire, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    ledgers_to_expire = Keyword.get(args, :ledgers_to_expire, 1)
    source_account = Keyword.get(args, :source_account)

    with {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{ledgers_to_expire: ledgers_to_expire, source_account: source_account}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_bump_footprint_op}

  @impl true
  def to_xdr(%__MODULE__{ledgers_to_expire: ledgers_to_expire}) do
    op_type = OperationType.new(:BUMP_FOOTPRINT_EXPIRATION)
    ledgers_to_expire = UInt32.new(ledgers_to_expire)

    Void.new()
    |> ExtensionPoint.new(0)
    |> BumpFootprintExpiration.new(ledgers_to_expire)
    |> OperationBody.new(op_type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
