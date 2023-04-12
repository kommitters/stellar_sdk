defmodule Stellar.TxBuild.SourceAccountContractID do
  @moduledoc """
  `SourceAccountContractID` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_string: 1,
      validate_account_id: 1
    ]

  alias StellarBase.XDR.{SourceAccountContractID, Hash, UInt256}
  alias Stellar.TxBuild.AccountID

  @type t :: %__MODULE__{
          network_id: binary(),
          source_account: AccountID.t(),
          salt: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :source_account, :salt]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    source_account = Keyword.get(args, :source_account)
    salt = Keyword.get(args, :salt)

    with {:ok, network_id} <- validate_string({:network_id, network_id}),
         {:ok, source_account} <- validate_account_id({:source_account, source_account}),
         {:ok, salt} <- validate_pos_integer({:salt, salt}) do
      %__MODULE__{
        network_id: network_id,
        source_account: source_account,
        salt: salt
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_source_account_contract_id}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        source_account: source_account,
        salt: salt
      }) do
    network_id = Hash.new(network_id)
    source_account = AccountID.to_xdr(source_account)
    salt = UInt256.new(salt)

    SourceAccountContractID.new(network_id, source_account, salt)
  end

  def to_xdr(_error), do: {:error, :invalid_source_account_contract_id}
end
