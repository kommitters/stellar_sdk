defmodule Stellar.Test.Fixtures.XDR do
  @moduledoc """
  Mocks for XDR constructions.
  """

  alias Stellar.Test.Fixtures.XDR.{
    Accounts,
    LiquidityPools,
    Predicates,
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

  # liquidity_pools
  defdelegate liquidity_pool_id(pool_id), to: LiquidityPools

  defdelegate liquidity_pool_withdraw(pool_id, amount, min_amount_a, min_amount_b),
    to: LiquidityPools

  # set_trustline
  defdelegate set_trustline_flags(trustor, asset, clear_flags, set_flags), to: Trustline

  # predicates
  defdelegate claim_predicate_unconditional(predicate), to: Predicates
  defdelegate claim_predicate_and(value, type), to: Predicates
  defdelegate claim_predicate_or(value, type), to: Predicates
  defdelegate claim_predicate_not(value, type), to: Predicates
  defdelegate claim_predicate_time_absolute(value, type, time_type), to: Predicates
  defdelegate claim_predicate_time_relative(value, type, time_type), to: Predicates
  defdelegate claim_predicates(value), to: Predicates
  defdelegate optional_predicate(value), to: Predicates
end
