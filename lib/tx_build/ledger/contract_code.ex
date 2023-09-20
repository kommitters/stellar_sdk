defmodule Stellar.TxBuild.Ledger.ContractCode do
  @moduledoc """
  `ContractCode` struct definition.
  """

  alias StellarBase.XDR.{Hash, LedgerKeyContractCode}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type hash :: String.t()

  @type t :: %__MODULE__{hash: hash()}

  defstruct [:hash]

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:hash, hash}
        ],
        _opts
      )
      when is_binary(hash) do
    %__MODULE__{
      hash: hash
    }
  end

  def new(_value, _opts), do: {:error, :invalid_ledger_key_args}

  @impl true
  def to_xdr(%__MODULE__{hash: hash}) do
    hash
    |> Hash.new()
    |> LedgerKeyContractCode.new()
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
