defmodule Stellar.Test.Fixtures do
  @moduledoc """
  Stellar's sample data for test constructions.
  """

  @spec account_data(public_key :: String.t()) :: String.t()
  def account_data(public_key) do
    ~s<{
        "_links": {
          "self": {
            "href": "https://horizon.stellar.org/accounts/#{public_key}"
          }
        },
        "id": "#{public_key}",
        "account_id": "#{public_key}",
        "sequence": "120192344791187470",
        "subentry_count": 5,
        "last_modified_ledger": 28105812,
        "num_sponsoring": 0,
        "num_sponsored": 0,
        "thresholds": {
          "low_threshold": 0,
          "med_threshold": 0,
          "high_threshold": 0
        },
        "balances": [
          {
            "balance": "100.0000000",
            "buying_liabilities": "0.0000000",
            "selling_liabilities": "0.0000000",
            "asset_type": "native"
          }
        ],
        "signers": [
          {
            "weight": 1,
            "key": "#{public_key}",
            "type": "ed25519_public_key"
          }
        ],
        "data": {},
        "paging_token": ""
      }>
  end
end
