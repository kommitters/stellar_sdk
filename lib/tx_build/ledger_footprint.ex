defmodule Stellar.TxBuild.LedgerFootprint do
  @moduledoc """
  `LedgerFootprint` struct definition.
  """

  alias Stellar.TxBuild.LedgerKey
  alias StellarBase.XDR.{LedgerFootprint, LedgerKeyList}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type ledger_key :: LedgerKey.t()
  @type ledger_keys :: list(ledger_key)

  @type t :: %__MODULE__{
          read_only: ledger_keys(),
          read_write: ledger_keys()
        }

  defstruct [:read_only, :read_write]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    read_only = Keyword.get(args, :read_only, [])
    read_write = Keyword.get(args, :read_write, [])

    with {:ok, read_only} <- validate_ledger_keys(read_only),
         {:ok, read_write} <- validate_ledger_keys(read_write) do
      %__MODULE__{
        read_only: read_only,
        read_write: read_write
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_ledger_footprint}

  @impl true
  def to_xdr(%__MODULE__{read_only: read_only, read_write: read_write}) do
    read_write = to_ledger_key_list(read_write)

    read_only
    |> to_ledger_key_list()
    |> LedgerFootprint.new(read_write)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_ledger_keys(keys :: ledger_keys()) :: validation()
  defp validate_ledger_keys(keys) when is_list(keys) do
    if Enum.all?(keys, &validate_ledger_key/1),
      do: {:ok, keys},
      else: {:error, :invalid_ledger_keys}
  end

  defp validate_ledger_keys(_keys), do: {:error, :invalid_ledger_keys}

  @spec validate_ledger_key(ledger_key()) :: boolean()
  defp validate_ledger_key(%LedgerKey{}), do: true
  defp validate_ledger_key(_key), do: false

  @spec to_ledger_key_list(keys :: ledger_keys()) :: LedgerKeyList.t()
  defp to_ledger_key_list(keys) do
    keys
    |> Enum.map(&LedgerKey.to_xdr/1)
    |> LedgerKeyList.new()
  end
end
