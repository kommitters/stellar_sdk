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
    Int64,
    Memo,
    MemoType,
    MuxedAccount,
    Operations,
    Operation,
    OperationBody,
    OperationType,
    OptionalMuxedAccount,
    PublicKey,
    PublicKeyType,
    Preconditions,
    PreconditionType,
    SequenceNumber,
    SignatureHint,
    Signature,
    TransactionEnvelope,
    TransactionV1Envelope,
    TransactionExt,
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
        tx: %Transaction{
          source_account: %MuxedAccount{
            type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519},
            account: %UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            }
          },
          fee: %UInt32{datum: 500},
          seq_num: %SequenceNumber{sequence_number: 123_456},
          preconditions: %Preconditions{
            preconditions: %Void{value: nil},
            type: %PreconditionType{identifier: :PRECOND_NONE}
          },
          memo: %Memo{
            value: %Void{value: nil},
            type: %MemoType{identifier: :MEMO_NONE}
          },
          operations: %Operations{
            operations: [
              %Operation{
                source_account: %OptionalMuxedAccount{
                  source_account: nil
                },
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
                }
              }
            ]
          },
          ext: %TransactionExt{
            value: %Void{value: nil},
            type: 0
          }
        },
        signatures: %DecoratedSignatures{
          signatures: [
            %DecoratedSignature{
              hint: %SignatureHint{hint: "ĄbM"},
              signature: %Signature{
                signature:
                  <<225, 112, 109, 120, 34, 50, 168, 153, 252, 232, 98, 180, 196, 198, 0, 234, 29,
                    165, 193, 231, 150, 126, 141, 3, 53, 22, 62, 175, 8, 149, 26, 80, 16, 201,
                    153, 21, 250, 214, 20, 109, 29, 10, 152, 147, 51, 73, 195, 209, 168, 197, 251,
                    120, 76, 131, 116, 226, 12, 119, 178, 36, 184, 74, 77, 1>>
              }
            },
            %DecoratedSignature{
              hint: %SignatureHint{hint: <<243, 78, 123, 134>>},
              signature: %Signature{
                signature:
                  <<63, 195, 169, 171, 125, 74, 56, 159, 75, 164, 41, 84, 45, 149, 30, 142, 88,
                    166, 177, 101, 100, 90, 149, 174, 7, 140, 182, 184, 135, 241, 9, 8, 131, 13,
                    242, 114, 254, 226, 45, 197, 225, 204, 117, 28, 233, 132, 37, 233, 221, 219,
                    123, 192, 245, 142, 72, 151, 86, 16, 203, 247, 113, 177, 121, 5>>
              }
            }
          ]
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_TX}
    }
  end

  def transaction_envelope(_opts) do
    %TransactionEnvelope{
      envelope: %TransactionV1Envelope{
        tx: %Transaction{
          source_account: %MuxedAccount{
            type: %CryptoKeyType{identifier: :KEY_TYPE_ED25519},
            account: %UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            }
          },
          fee: %UInt32{datum: 500},
          seq_num: %SequenceNumber{sequence_number: 123_456},
          preconditions: %Preconditions{
            preconditions: %Void{value: nil},
            type: %PreconditionType{identifier: :PRECOND_NONE}
          },
          memo: %Memo{
            value: nil,
            type: %MemoType{identifier: :MEMO_NONE}
          },
          operations: %Operations{
            operations: [
              %Operation{
                source_account: %OptionalMuxedAccount{
                  source_account: nil
                },
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
                }
              }
            ]
          },
          ext: %TransactionExt{
            value: %Void{value: nil},
            type: 0
          }
        },
        signatures: %DecoratedSignatures{
          signatures: [
            %DecoratedSignature{
              hint: %SignatureHint{hint: "ĄbM"},
              signature: %Signature{
                signature:
                  <<225, 112, 109, 120, 34, 50, 168, 153, 252, 232, 98, 180, 196, 198, 0, 234, 29,
                    165, 193, 231, 150, 126, 141, 3, 53, 22, 62, 175, 8, 149, 26, 80, 16, 201,
                    153, 21, 250, 214, 20, 109, 29, 10, 152, 147, 51, 73, 195, 209, 168, 197, 251,
                    120, 76, 131, 116, 226, 12, 119, 178, 36, 184, 74, 77, 1>>
              }
            }
          ]
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_TX}
    }
  end
end
