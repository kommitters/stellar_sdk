defmodule Stellar.TxBuild.ExtendFootprintTTL do
  @moduledoc """
  `ExtendFootprintTTL` struct definition.
  """
  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.OptionalAccount

  alias StellarBase.XDR.{
    ExtensionPoint,
    OperationBody,
    OperationType,
    Operations.ExtendFootprintTTL,
    UInt32,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type extend_to :: integer()

  @type t :: %__MODULE__{
          extend_to: extend_to(),
          source_account: OptionalAccount.t()
        }

  defstruct [:extend_to, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    extend_to = Keyword.get(args, :extend_to, 1)
    source_account = Keyword.get(args, :source_account)

    with {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{extend_to: extend_to, source_account: source_account}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_bump_footprint_op}

  @impl true
  def to_xdr(%__MODULE__{extend_to: extend_to}) do
    op_type = OperationType.new(:EXTEND_FOOTPRINT_TTL)
    extend_to = UInt32.new(extend_to)

    Void.new()
    |> ExtensionPoint.new(0)
    |> ExtendFootprintTTL.new(extend_to)
    |> OperationBody.new(op_type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
