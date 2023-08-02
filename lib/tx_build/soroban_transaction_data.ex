defmodule Stellar.TxBuild.SorobanTransactionData do
  @moduledoc """
  `SorobanTransactionData` struct definition.
  """
  alias StellarBase.XDR.{
    ExtensionPoint,
    Int64,
    SorobanTransactionData,
    Void
  }

  alias Stellar.TxBuild.SorobanResources

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type resources :: SorobanResources.t()
  @type refundable_fee :: non_neg_integer()

  @type t :: %__MODULE__{
          resources: resources(),
          refundable_fee: refundable_fee()
        }

  defstruct [:resources, :refundable_fee]

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:resources, resources},
          {:refundable_fee, refundable_fee}
        ],
        _opts
      )
      when is_integer(refundable_fee) and refundable_fee >= 0 do
    with {:ok, resources} <- validate_resources(resources) do
      %__MODULE__{
        resources: resources,
        refundable_fee: refundable_fee
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_soroban_transaction_data}

  @impl true
  def to_xdr(%__MODULE__{resources: resources, refundable_fee: refundable_fee}) do
    resources = SorobanResources.to_xdr(resources)
    refundable_fee = Int64.new(refundable_fee)

    Void.new()
    |> ExtensionPoint.new(0)
    |> SorobanTransactionData.new(resources, refundable_fee)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_resources(resources :: resources()) :: validation()
  defp validate_resources(%SorobanResources{} = resources), do: {:ok, resources}
  defp validate_resources(_resources), do: {:error, :invalid_resources}
end
