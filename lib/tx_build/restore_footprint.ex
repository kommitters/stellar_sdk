defmodule Stellar.TxBuild.RestoreFootprint do
  @moduledoc """
  `RestoreFootprint` struct definition.
  """
  alias Stellar.TxBuild.OptionalAccount

  alias StellarBase.XDR.{
    ExtensionPoint,
    Operations.RestoreFootprint,
    OperationBody,
    OperationType,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type value :: nil

  @type t :: %__MODULE__{value: value(), source_account: OptionalAccount.t()}

  defstruct [:value, :source_account]

  @impl true
  def new(value \\ nil, opts \\ [])
  def new(_value, _opts), do: %__MODULE__{value: nil, source_account: OptionalAccount.new()}

  @impl true
  def to_xdr(%__MODULE__{value: _value}) do
    op_type = OperationType.new(:RESTORE_FOOTPRINT)

    Void.new()
    |> ExtensionPoint.new(0)
    |> RestoreFootprint.new()
    |> OperationBody.new(op_type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
