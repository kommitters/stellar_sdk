defmodule Stellar.TxBuild.BaseFee do
  @moduledoc """
  `BaseFee` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{fee: non_neg_integer()}

  defstruct [:fee]

  @impl true
  def new(operations_count \\ 0, opts \\ [])

  def new(0, _opts), do: %__MODULE__{fee: base_fee()}

  def new(operations_count, _opts) when is_integer(operations_count) do
    %__MODULE__{fee: base_fee() * operations_count}
  end

  def new(_fee, _multiplier), do: {:error, :invalid_fee}

  @impl true
  def to_xdr(%__MODULE__{fee: fee}) do
    UInt32.new(fee)
  end

  @spec base_fee() :: non_neg_integer()
  defp base_fee, do: 100
end
