defmodule Stellar.Test.Fixtures.XDR.Accounts do
  @moduledoc """
  XDR constructions for Accounts.
  """

  alias StellarBase.XDR.{CryptoKeyType, MuxedAccount, MuxedAccountMed25519, UInt256, UInt64}

  @type account_id :: String.t()
  @type address :: String.t()
  @type xdr :: MuxedAccount.t() | :error

  @spec muxed_account(account_id :: account_id()) :: xdr()
  def muxed_account("GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH") do
    %MuxedAccount{
      account: %UInt256{
        datum:
          <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92, 222, 73,
            207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
      },
      type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519}
    }
  end

  def muxed_account(_address), do: :error

  @spec muxed_account_med25519(address :: address()) :: xdr()
  def muxed_account_med25519(
        "MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ"
      ) do
    %MuxedAccount{
      account: %MuxedAccountMed25519{
        ed25519: %UInt256{
          datum:
            <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92, 222, 73,
              207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
        },
        id: %UInt64{datum: 4}
      },
      type: %CryptoKeyType{identifier: :KEY_TYPE_MUXED_ED25519}
    }
  end

  def muxed_account_med25519(_address), do: :error
end
