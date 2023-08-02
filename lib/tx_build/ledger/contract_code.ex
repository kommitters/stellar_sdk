defmodule Stellar.TxBuild.Ledger.ContractCode do
  @moduledoc """
  `ContractCode` struct definition.
  """

  alias StellarBase.XDR.{ContractEntryBodyType, Hash, LedgerKeyContractCode}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type hash :: String.t()
  @type body_type :: :data_entry | :expiration_ext

  @type t :: %__MODULE__{
          hash: hash(),
          body_type: body_type()
        }

  defstruct [:hash, :body_type]

  @allowed_body_types ~w(data_entry expiration_ext)a

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:hash, hash},
          {:body_type, body_type}
        ],
        _opts
      )
      when is_binary(hash) and body_type in @allowed_body_types do
    %__MODULE__{
      hash: hash,
      body_type: body_type
    }
  end

  def new(_value, _opts), do: {:error, :invalid_ledger_key_args}

  @impl true
  def to_xdr(%__MODULE__{
        hash: hash,
        body_type: body_type
      }) do
    body_type = body_type_to_xdr(body_type)

    hash
    |> Hash.new()
    |> LedgerKeyContractCode.new(body_type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec body_type_to_xdr(atom()) :: ContractEntryBodyType.t()
  defp body_type_to_xdr(:data_entry), do: ContractEntryBodyType.new(:DATA_ENTRY)
  defp body_type_to_xdr(:expiration_ext), do: ContractEntryBodyType.new(:EXPIRATION_EXTENSION)
end
