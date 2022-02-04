---
title: Create an account
---

## Create an account

```elixir
# 1. set the founder account
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# 2. set the next sequence number for the founder account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the create_account operation
operation = Stellar.TxBuild.CreateAccount.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    starting_balance: 2
  )

# 4. build the tx signatures
signer_key_pair = Stellar.KeyPair.from_secret_seed("SECRET_SEED")
signature = Stellar.TxBuild.Signature.new(signer_key_pair)

# 5. submit the transaction to Horizon
{:ok, tx} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()
  |> Stellar.Horizon.Transactions.create()
```
