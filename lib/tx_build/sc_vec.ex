defmodule Stellar.TxBuild.SCVec do
  @moduledoc """
  `ScVec` struct definition.
  """
  alias Stellar.TxBuild.SCVal
  alias StellarBase.XDR.SCVec

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type items :: list(SCVal.t())

  @type t :: %__MODULE__{items: items()}

  defstruct [:items]

  @impl true
  def new(items, opts \\ [])

  def new(items, _opts) when is_list(items) do
    with {:ok, items} <- validate_vec_items(items) do
      %__MODULE__{items: items}
    end
  end

  def new(_items, _opts), do: {:error, :invalid_sc_vec}

  @impl true
  def to_xdr(%__MODULE__{items: items}) do
    items
    |> Enum.map(&SCVal.to_xdr/1)
    |> SCVec.new()
  end

  @spec append_sc_val(t(), item :: SCVal.t()) :: t() | error()
  def append_sc_val(%__MODULE__{items: items} = module, %SCVal{} = item),
    do: %{module | items: items ++ [item]}

  def append_sc_val(_module, _item), do: {:error, :invalid_item}

  @spec validate_vec_items(items :: items()) :: validation()
  defp validate_vec_items(items) do
    if Enum.all?(items, &is_sc_val?/1),
      do: {:ok, items},
      else: {:error, :invalid_vec}
  end

  @spec is_sc_val?(value :: any()) :: boolean()
  defp is_sc_val?(%SCVal{}), do: true
  defp is_sc_val?(_), do: false
end
