defmodule Stellar.Test.Fixtures.XDR do
  @moduledoc """
  Mocks for XDR constructions.
  """

  alias Stellar.Test.Fixtures.XDR.{
    Accounts,
    ClaimableBalances,
    LiquidityPools,
    Transactions,
    TransactionEnvelope,
    Trustline
  }

  # accounts
  defdelegate muxed_account(account_id), to: Accounts
  defdelegate muxed_account_med25519(address), to: Accounts

  # transactions
  defdelegate transaction(account_id), to: Transactions
  defdelegate transaction_with_muxed_account(address), to: Transactions

  # transactions envelope
  defdelegate transaction_envelope(options \\ []), to: TransactionEnvelope

  # liquidity pools
  defdelegate liquidity_pool_id(pool_id), to: LiquidityPools

  # claimable balances
  defdelegate claimable_balance_id(balance_id), to: ClaimableBalances
  defdelegate clawback_claimable_balance(balance_id), to: ClaimableBalances
  defdelegate claim_claimable_balance(balance_id), to: ClaimableBalances

  defdelegate liquidity_pool_withdraw(pool_id, amount, min_amount_a, min_amount_b),
    to: LiquidityPools

  defdelegate liquidity_pool_deposit(pool_id, max_amount_a, max_amount_b, min_price, max_price),
    to: LiquidityPools

  # set_trustline
  defdelegate set_trustline_flags(trustor, asset, clear_flags, set_flags), to: Trustline
end
