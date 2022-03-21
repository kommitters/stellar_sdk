defmodule Stellar.Test.Fixtures.XDR.TransactionEnvelope do
  @moduledoc """
  XDR constructions for Transaction Envelopes.
  """

  alias StellarBase.XDR.{
    AccountID,
    CryptoKeyType,
    DecoratedSignatures,
    DecoratedSignature,
    EnvelopeType,
    Ext,
    Int64,
    Memo,
    MemoType,
    MuxedAccount,
    Operations,
    Operation,
    OperationBody,
    OperationType,
    OptionalMuxedAccount,
    OptionalTimeBounds,
    PublicKey,
    PublicKeyType,
    SequenceNumber,
    SignatureHint,
    Signature,
    TransactionEnvelope,
    TransactionV1Envelope,
    Transaction,
    UInt32,
    UInt256,
    Void
  }

  @type xdr :: TransactionEnvelope.t() | :error

  @spec transaction_envelope(opts :: Keyword.t()) :: xdr()
  def transaction_envelope(opts \\ [])

  def transaction_envelope(
        extra_signatures: ["SAALZGBDHMY5NQGU2L6G4GHQ65ESCDQD5TNYPWM5AZDVB3HICLKF4KI3"]
      ) do
    %TransactionEnvelope{
      envelope: %TransactionV1Envelope{
        signatures: %DecoratedSignatures{
          signatures: [
            %DecoratedSignature{
              hint: %SignatureHint{hint: "ĄbM"},
              signature: %Signature{
                signature:
                  <<253, 149, 211, 55, 48, 158, 152, 254, 140, 193, 191, 210, 24, 133, 6, 132, 82,
                    164, 255, 14, 21, 86, 234, 194, 176, 151, 251, 181, 222, 203, 172, 42, 39,
                    123, 12, 49, 146, 180, 6, 54, 230, 152, 56, 52, 213, 150, 164, 5, 28, 218,
                    124, 70, 22, 80, 180, 143, 226, 230, 80, 208, 229, 158, 106, 1>>
              }
            },
            %DecoratedSignature{
              hint: %SignatureHint{hint: <<243, 78, 123, 134>>},
              signature: %Signature{
                signature:
                  <<255, 230, 83, 225, 218, 46, 235, 47, 169, 101, 241, 154, 58, 10, 243, 98, 126,
                    22, 145, 219, 93, 65, 214, 204, 232, 252, 129, 8, 233, 17, 73, 225, 246, 97,
                    56, 92, 66, 144, 101, 129, 241, 64, 158, 20, 88, 69, 207, 115, 159, 236, 8,
                    80, 38, 91, 125, 149, 224, 30, 3, 153, 118, 143, 116, 3>>
              }
            }
          ]
        },
        tx: %Transaction{
          ext: %Ext{
            type: 0,
            value: %Void{value: nil}
          },
          fee: %UInt32{datum: 50_000},
          memo: %Memo{
            type: %MemoType{identifier: :MEMO_NONE},
            value: %Void{value: nil}
          },
          operations: %Operations{
            operations: [
              %Operation{
                body: %OperationBody{
                  operation: %Operations.CreateAccount{
                    destination: %AccountID{
                      account_id: %PublicKey{
                        public_key: %UInt256{
                          datum:
                            <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97,
                              106, 93, 18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132,
                              98, 77>>
                        },
                        type: %PublicKeyType{
                          identifier: :PUBLIC_KEY_TYPE_ED25519
                        }
                      }
                    },
                    starting_balance: %Int64{datum: 15_000_000}
                  },
                  type: %OperationType{identifier: :CREATE_ACCOUNT}
                },
                source_account: %OptionalMuxedAccount{
                  source_account: nil
                }
              }
            ]
          },
          seq_num: %SequenceNumber{sequence_number: 123_456},
          source_account: %MuxedAccount{
            account: %UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519}
          },
          time_bounds: %OptionalTimeBounds{time_bounds: nil}
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_TX}
    }
  end

  def transaction_envelope(_opts) do
    %TransactionEnvelope{
      envelope: %TransactionV1Envelope{
        signatures: %DecoratedSignatures{
          signatures: [
            %DecoratedSignature{
              hint: %SignatureHint{hint: "ĄbM"},
              signature: %Signature{
                signature:
                  <<253, 149, 211, 55, 48, 158, 152, 254, 140, 193, 191, 210, 24, 133, 6, 132, 82,
                    164, 255, 14, 21, 86, 234, 194, 176, 151, 251, 181, 222, 203, 172, 42, 39,
                    123, 12, 49, 146, 180, 6, 54, 230, 152, 56, 52, 213, 150, 164, 5, 28, 218,
                    124, 70, 22, 80, 180, 143, 226, 230, 80, 208, 229, 158, 106, 1>>
              }
            }
          ]
        },
        tx: %Transaction{
          ext: %Ext{
            type: 0,
            value: %Void{value: nil}
          },
          fee: %UInt32{datum: 50_000},
          memo: %Memo{
            type: %MemoType{identifier: :MEMO_NONE},
            value: nil
          },
          operations: %Operations{
            operations: [
              %Operation{
                body: %OperationBody{
                  operation: %Operations.CreateAccount{
                    destination: %AccountID{
                      account_id: %PublicKey{
                        public_key: %UInt256{
                          datum:
                            <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97,
                              106, 93, 18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132,
                              98, 77>>
                        },
                        type: %PublicKeyType{
                          identifier: :PUBLIC_KEY_TYPE_ED25519
                        }
                      }
                    },
                    starting_balance: %Int64{datum: 15_000_000}
                  },
                  type: %OperationType{identifier: :CREATE_ACCOUNT}
                },
                source_account: %OptionalMuxedAccount{
                  source_account: nil
                }
              }
            ]
          },
          seq_num: %SequenceNumber{sequence_number: 123_456},
          source_account: %MuxedAccount{
            account: %UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519}
          },
          time_bounds: %OptionalTimeBounds{time_bounds: nil}
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_TX}
    }
  end
end
