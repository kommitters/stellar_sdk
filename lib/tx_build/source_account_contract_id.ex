defmodule Stellar.TxBuild.SourceAccountContractID do
  @moduledoc """
  `SourceAccountContractID` struct definition.
  """

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

  def new(
        [
          network_id,
          %AccountID{} = source_account,
          salt
        ],
        _opts
      )
      when is_binary(network_id) and is_integer(salt) and salt >= 0 do
    %__MODULE__{
      network_id: network_id,
      source_account: source_account,
      salt: salt
    }
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
