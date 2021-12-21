defmodule Stellar.TxBuild.Flags do
  @moduledoc """
  `Flags` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @behaviour Stellar.TxBuild.XDR

  @type flags :: list(atom())

  @type t :: %__MODULE__{value: flags()}

  defstruct [:value]

  @flags [required: 0x1, revocable: 0x2, inmutable: 0x4, clawback_enabled: 0x8]

  @impl true
  def new(flags \\ [], opts \\ [])

  def new(flags, _opts) when is_list(flags) do
    %__MODULE__{value: flags_bit_mask(flags)}
  end

  def new(_value, _opts), do: {:error, :invalid_flags}

  @impl true
  def to_xdr(%__MODULE__{value: weight}) do
    UInt32.new(weight)
  end

  @spec flags_bit_mask(flags :: flags()) :: integer()
  defp flags_bit_mask(flags) do
    flags
    |> Enum.filter(&is_atom(&1))
    |> Enum.map(&Keyword.get(@flags, &1, 0x0))
    |> Enum.reduce(0, &(&1 + &2))
  end
end
