defmodule Stellar.TxBuild.SCMapEntry do
  @moduledoc """
  `SCMapEntry` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.TxBuild.SCVal
  alias StellarBase.XDR.SCMapEntry

  @type t :: %__MODULE__{key: SCVal.t(), val: SCVal.t()}

  defstruct [:key, :val]

  @impl true
  def new(key, val, opts \\ nil)

  def new(%SCVal{} = key, %SCVal{} = val, _opts), do: %__MODULE__{key: key, val: val}

  def new(_key, _val, _opts), do: {:error, :invalid_sc_map_entry}

  @impl true
  def to_xdr(%__MODULE__{key: key, val: val}) do
    key = SCVal.to_xdr(key)
    val = SCVal.to_xdr(val)

    SCMapEntry.new(key, val)
  end
end
