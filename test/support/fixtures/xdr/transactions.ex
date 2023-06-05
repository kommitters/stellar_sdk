defmodule Stellar.Test.Fixtures.XDR.Transactions do
  @moduledoc """
  XDR constructions for Transactions.
  """

  alias StellarBase.XDR.{
    Transaction,
    TransactionExt,
    UInt32,
    Memo,
    MemoType,
    Operations,
    SequenceNumber,
    MuxedAccount,
    MuxedAccountMed25519,
    UInt256,
    UInt64,
    CryptoKeyType,
    Void,
    Preconditions,
    PreconditionType
  }

  @type account_id :: String.t()
  @type address :: String.t()
  @type xdr :: Transaction.t() | :error

  @spec transaction(account_id :: account_id()) :: xdr()
  def transaction("GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH") do
    %Transaction{
      ext: %TransactionExt{type: 0, value: %Void{value: nil}},
      fee: %UInt32{datum: 100},
      memo: %Memo{
        type: %MemoType{identifier: :MEMO_NONE},
        value: nil
      },
      operations: %Operations{operations: []},
      seq_num: %SequenceNumber{sequence_number: 4_130_487_228_432_385},
      source_account: %MuxedAccount{
        account: %UInt256{
          datum:
            <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92, 222, 73,
              207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
        },
        type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519}
      },
      preconditions: %Preconditions{
        type: %PreconditionType{identifier: :PRECOND_NONE},
        preconditions: %Void{value: nil}
      }
    }
  end

  def transaction(_address), do: :error

  @spec transaction_with_muxed_account(address :: address()) :: xdr()
  def transaction_with_muxed_account(
        "MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ"
      ) do
    %Transaction{
      ext: %TransactionExt{type: 0, value: %Void{value: nil}},
      fee: %UInt32{datum: 100},
      memo: %Memo{
        type: %MemoType{identifier: :MEMO_NONE},
        value: nil
      },
      operations: %Operations{operations: []},
      seq_num: %SequenceNumber{sequence_number: 4_130_487_228_432_385},
      source_account: %MuxedAccount{
        account: %MuxedAccountMed25519{
          ed25519: %UInt256{
            datum:
              <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92, 222, 73,
                207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
          },
          id: %UInt64{datum: 4}
        },
        type: %CryptoKeyType{identifier: :KEY_TYPE_MUXED_ED25519}
      },
      preconditions: %Preconditions{
        type: %PreconditionType{identifier: :PRECOND_NONE},
        preconditions: %Void{value: nil}
      }
    }
  end

  def transaction_with_muxed_account(_address), do: :error
end
