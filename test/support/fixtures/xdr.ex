defmodule Stellar.Test.Fixtures.XDR do
  @moduledoc """
  Mocks for XDR constructions.
  """

  alias Stellar.Test.Fixtures.XDR.{
    Accounts,
    ClaimableBalances,
    Ledger,
    LiquidityPools,
    Predicates,
    Signatures,
    Transactions,
    TransactionEnvelope,
    Trustline
  }

  # accounts
  defdelegate muxed_account(account_id), to: Accounts
  defdelegate muxed_account_med25519(address), to: Accounts

  # signatures
  defdelegate ed25519_signer_key(key), to: Signatures
  defdelegate sha256_hash_signer_key(key), to: Signatures
  defdelegate pre_auth_signer_key(key), to: Signatures
  defdelegate ed25519_signed_payload_signer_key(key), to: Signatures
  defdelegate ed25519_signer(key, weight), to: Signatures
  defdelegate sha256_hash_signer(key, weight), to: Signatures
  defdelegate pre_auth_signer(key, weight), to: Signatures
  defdelegate ed25519_signed_payload_signer(key, weight), to: Signatures
  defdelegate ed25519_revoke_sponsorship_signer(account_id, key), to: Signatures
  defdelegate sha256_hash_revoke_sponsorship_signer(account_id, key), to: Signatures
  defdelegate pre_auth_revoke_sponsorship_signer(account_id, key), to: Signatures

  defdelegate ed25519_signed_payload_revoke_sponsorship_signer(account_id, key),
    to: Signatures

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
  defdelegate trustline_asset(asset), to: Trustline

  # predicates
  defdelegate claim_predicate_unconditional(predicate), to: Predicates
  defdelegate claim_predicate_and(value, type), to: Predicates
  defdelegate claim_predicate_or(value, type), to: Predicates
  defdelegate claim_predicate_not(value, type), to: Predicates
  defdelegate claim_predicate_time_absolute(value, type, time_type), to: Predicates
  defdelegate claim_predicate_time_relative(value, type, time_type), to: Predicates
  defdelegate claim_predicates(value), to: Predicates
  defdelegate optional_predicate(value), to: Predicates
  defdelegate optional_predicate_with_nil_value(value), to: Predicates
  defdelegate claimant(destination, predicate), to: Predicates
  defdelegate claimants(claimants), to: Predicates
  defdelegate create_claimable_balance(asset, amount, claimants), to: Predicates

  # ledger entries
  defdelegate ledger_account(account_id), to: Ledger
  defdelegate ledger_trustline(account_id, asset), to: Ledger
  defdelegate ledger_offer(seller_id, offer_id), to: Ledger
  defdelegate ledger_data(account_id, data_name), to: Ledger
  defdelegate ledger_claimable_balance(claimable_balance_id), to: Ledger
  defdelegate ledger_liquidity_pool(liquidity_pool_id), to: Ledger

  defdelegate ledger_key_account(account_id), to: Ledger
  defdelegate ledger_key_trustline(account_id, asset), to: Ledger
  defdelegate ledger_key_offer(seller_id, offer_id), to: Ledger
  defdelegate ledger_key_data(account_id, data_name), to: Ledger
  defdelegate ledger_key_claimable_balance(claimable_balance_id), to: Ledger
  defdelegate ledger_key_liquidity_pool(liquidity_pool_id), to: Ledger
  defdelegate ledger_key_contract_data(), to: Ledger
  defdelegate ledger_key_contract_code(), to: Ledger
  defdelegate ledger_key_config_setting(), to: Ledger
  defdelegate ledger_key_ttl(), to: Ledger

  defdelegate revoke_sponsorship(type, attrs), to: Ledger
end
