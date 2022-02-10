defmodule Stellar.Test.Fixtures.XDR do
  @moduledoc """
  Mocks for XDR constructions.
  """

  alias Stellar.Test.Fixtures.XDR.{Accounts, Transactions}

  # accounts
  defdelegate muxed_account(account_id), to: Accounts
  defdelegate muxed_account_med25519(address), to: Accounts

  # transactions
  defdelegate transaction(account_id), to: Transactions
  defdelegate transaction_with_muxed_account(address), to: Transactions
end
