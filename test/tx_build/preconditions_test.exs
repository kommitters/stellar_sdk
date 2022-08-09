defmodule Stellar.TxBuild.PreconditionsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    Preconditions,
    TimeBounds,
    LedgerBounds,
    SequenceNumber,
    SignerKey,
    OptionalSequenceNumber
  }

  alias StellarBase.XDR.{
    PreconditionsV2,
    PreconditionType,
    Duration,
    TimePoint,
    OptionalTimeBounds,
    OptionalLedgerBounds,
    SignerKeyList,
    SignerKeyType,
    UInt32,
    UInt256,
    Void
  }

  alias StellarBase.XDR.SignerKey, as: SignerKeyXDR
  alias StellarBase.XDR.SequenceNumber, as: SequenceNumberXDR
  alias StellarBase.XDR.Preconditions, as: PreconditionsXDR
  alias StellarBase.XDR.TimeBounds, as: TimeBoundsXDR
  alias StellarBase.XDR.OptionalSequenceNumber, as: OptionalSequenceNumberXDR

  setup do
    extra_signers = [
      "GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH",
      "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC"
    ]

    extra_signers_sdk = extra_signers |> Enum.map(&SignerKey.new(&1))

    %{
      time_bounds: TimeBounds.new(:none),
      ledger_bounds: LedgerBounds.new(:none),
      min_seq_num: SequenceNumber.new(),
      min_seq_age: 1500,
      min_seq_ledger_gap: 2500,
      extra_signers_sdk: extra_signers_sdk,
      extra_signers: extra_signers
    }
  end

  describe "validations" do
    test "with invalid time_bounds", %{
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers
    } do
      {:error, :invalid_time_bounds} =
        Preconditions.new(
          time_bounds: nil,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end

    test "with invalid ledger_bounds", %{
      time_bounds: time_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers
    } do
      {:error, :invalid_ledger_bounds} =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: nil,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end

    test "with invalid min_seq_num", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers
    } do
      {:error, :invalid_min_seq_num} =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: -250_000,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end

    test "with invalid min_seq_age", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers
    } do
      {:error, :invalid_min_seq_age} =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: -123_456,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end

    test "with invalid min_seq_ledger_gap", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      extra_signers: extra_signers
    } do
      {:error, :invalid_min_seq_ledger_gap} =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: -654_321,
          extra_signers: extra_signers
        )
    end

    test "with invalid extra_signers", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap
    } do
      {:error, :invalid_extra_signers} =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: nil
        )
    end
  end

  describe "new/2" do
    test "Precondition type none" do
      %Preconditions{type: :none, preconditions: nil} = Preconditions.new([])
    end

    test "Precondition type precond_time", %{time_bounds: time_bounds} do
      %Preconditions{type: :precond_time, preconditions: ^time_bounds} =
        Preconditions.new(time_bounds: time_bounds)
    end

    test "Precondition type precond_v2", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers,
      extra_signers_sdk: extra_signers_sdk
    } do
      optional_min_seq_num = OptionalSequenceNumber.new(min_seq_num)

      %Preconditions{
        type: :precond_v2,
        preconditions: [
          time_bounds: ^time_bounds,
          ledger_bounds: ^ledger_bounds,
          min_seq_num: ^optional_min_seq_num,
          min_seq_age: ^min_seq_age,
          min_seq_ledger_gap: ^min_seq_ledger_gap,
          extra_signers: ^extra_signers_sdk
        ]
      } =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end

    test "Precondition type precond_v2 with min_seq_num nil", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers: extra_signers,
      extra_signers_sdk: extra_signers_sdk
    } do
      optional_min_seq_num = OptionalSequenceNumber.new()

      %Preconditions{
        type: :precond_v2,
        preconditions: [
          time_bounds: ^time_bounds,
          ledger_bounds: ^ledger_bounds,
          min_seq_num: ^optional_min_seq_num,
          min_seq_age: ^min_seq_age,
          min_seq_ledger_gap: ^min_seq_ledger_gap,
          extra_signers: ^extra_signers_sdk
        ]
      } =
        Preconditions.new(
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        )
    end
  end

  describe "to_xdr/1" do
    test "Precondition type none" do
      %PreconditionsXDR{
        type: %PreconditionType{identifier: :PRECOND_NONE},
        preconditions: %Void{value: nil}
      } = Preconditions.to_xdr(%Preconditions{type: :none, preconditions: nil})
    end

    test "Precondition type precond_time" do
      %PreconditionsXDR{
        type: %PreconditionType{identifier: :PRECOND_TIME},
        preconditions: %TimeBoundsXDR{
          min_time: %TimePoint{value: 0},
          max_time: %TimePoint{value: 0}
        }
      } =
        Preconditions.to_xdr(%Preconditions{
          type: :precond_time,
          preconditions: %TimeBounds{min_time: 0, max_time: 0}
        })
    end

    test "Preconditions type precond_v2", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_num: min_seq_num,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers_sdk: extra_signers_sdk
    } do
      optional_min_seq_num = OptionalSequenceNumber.new(min_seq_num)

      %PreconditionsXDR{
        type: %PreconditionType{identifier: :PRECOND_V2},
        preconditions: %PreconditionsV2{
          time_bounds: %OptionalTimeBounds{time_bounds: nil},
          ledger_bounds: %OptionalLedgerBounds{ledger_bounds: nil},
          min_seq_num: %OptionalSequenceNumberXDR{
            sequence_number: %SequenceNumberXDR{sequence_number: 0}
          },
          min_seq_age: %Duration{value: 1500},
          min_seq_ledger_gap: %UInt32{datum: 2500},
          extra_signers: %SignerKeyList{
            signer_keys: [
              %SignerKeyXDR{
                signer_key: %UInt256{
                  datum:
                    <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92,
                      222, 73, 207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
                },
                type: %SignerKeyType{
                  identifier: :SIGNER_KEY_TYPE_ED25519
                }
              },
              %StellarBase.XDR.SignerKey{
                signer_key: %StellarBase.XDR.UInt256{
                  datum:
                    <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129,
                      248, 20, 182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>
                },
                type: %StellarBase.XDR.SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
              }
            ]
          }
        }
      } =
        Preconditions.to_xdr(%Preconditions{
          type: :precond_v2,
          preconditions: [
            time_bounds: time_bounds,
            ledger_bounds: ledger_bounds,
            min_seq_num: optional_min_seq_num,
            min_seq_age: min_seq_age,
            min_seq_ledger_gap: min_seq_ledger_gap,
            extra_signers: extra_signers_sdk
          ]
        })
    end

    test "Preconditions type precond_v2 with min_seq_num nil", %{
      time_bounds: time_bounds,
      ledger_bounds: ledger_bounds,
      min_seq_age: min_seq_age,
      min_seq_ledger_gap: min_seq_ledger_gap,
      extra_signers_sdk: extra_signers_sdk
    } do
      optional_min_seq_num = OptionalSequenceNumber.new()

      %PreconditionsXDR{
        type: %PreconditionType{identifier: :PRECOND_V2},
        preconditions: %PreconditionsV2{
          time_bounds: %OptionalTimeBounds{time_bounds: nil},
          ledger_bounds: %OptionalLedgerBounds{ledger_bounds: nil},
          min_seq_num: %OptionalSequenceNumberXDR{sequence_number: nil},
          min_seq_age: %Duration{value: 1500},
          min_seq_ledger_gap: %UInt32{datum: 2500},
          extra_signers: %SignerKeyList{
            signer_keys: [
              %SignerKeyXDR{
                signer_key: %UInt256{
                  datum:
                    <<111, 94, 211, 67, 247, 211, 243, 210, 220, 210, 84, 19, 15, 150, 110, 92,
                      222, 73, 207, 189, 198, 89, 226, 31, 8, 156, 110, 212, 64, 137, 133, 22>>
                },
                type: %SignerKeyType{
                  identifier: :SIGNER_KEY_TYPE_ED25519
                }
              },
              %StellarBase.XDR.SignerKey{
                signer_key: %StellarBase.XDR.UInt256{
                  datum:
                    <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129,
                      248, 20, 182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>
                },
                type: %StellarBase.XDR.SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
              }
            ]
          }
        }
      } =
        Preconditions.to_xdr(%Preconditions{
          type: :precond_v2,
          preconditions: [
            time_bounds: time_bounds,
            ledger_bounds: ledger_bounds,
            min_seq_num: optional_min_seq_num,
            min_seq_age: min_seq_age,
            min_seq_ledger_gap: min_seq_ledger_gap,
            extra_signers: extra_signers_sdk
          ]
        })
    end
  end
end
