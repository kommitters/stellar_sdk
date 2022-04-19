defmodule Stellar.Test.Fixtures.XDR.ClaimableBalances do
  @moduledoc """
  XDR constructions for ClaimableBalances.
  """

  alias StellarBase.XDR.{
    ClaimableBalanceID,
    ClaimableBalanceIDType,
    Hash,
    Operations,
    OperationBody,
    OperationType
  }

  @type balance_id :: String.t()
  @type xdr ::
          ClaimableBalanceID.t()
          | ClawbackClaimableBalance.t()
          | ClaimClaimableBalance.t()
          | :error

  @spec claimable_balance_id(balance_id :: balance_id()) :: xdr()
  def claimable_balance_id(
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %ClaimableBalanceID{
      claimable_balance_id: %Hash{
        value:
          <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49, 141,
            141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
      },
      type: %ClaimableBalanceIDType{identifier: :CLAIMABLE_BALANCE_ID_TYPE_V0}
    }
  end

  def claimable_balance_id(_balance_id), do: :error

  @spec clawback_claimable_balance(balance_id :: balance_id()) :: xdr()
  def clawback_claimable_balance(
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %OperationBody{
      operation: %Operations.ClawbackClaimableBalance{
        balance_id: %ClaimableBalanceID{
          claimable_balance_id: %Hash{
            value:
              <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
                141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
          },
          type: %ClaimableBalanceIDType{identifier: :CLAIMABLE_BALANCE_ID_TYPE_V0}
        }
      },
      type: %OperationType{identifier: :CLAWBACK_CLAIMABLE_BALANCE}
    }
  end

  def clawback_claimable_balance(_balance_id), do: :error

  @spec claim_claimable_balance(balance_id :: balance_id()) :: xdr()
  def claim_claimable_balance(
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %OperationBody{
      operation: %Operations.ClaimClaimableBalance{
        balance_id: %ClaimableBalanceID{
          claimable_balance_id: %Hash{
            value:
              <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
                141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
          },
          type: %ClaimableBalanceIDType{identifier: :CLAIMABLE_BALANCE_ID_TYPE_V0}
        }
      },
      type: %OperationType{identifier: :CLAIM_CLAIMABLE_BALANCE}
    }
  end

  def claim_claimable_balance(_balance_id), do: :error
end
