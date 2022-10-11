# Pre-authorized transaction Signer

You can actually sign a transaction "in advance", such that it might be valid in the future. To accomplish this, you add the *hash* of the transaction as a signer on the account. Then, when that transaction actually gets submitted to the network, it acts as if it was already signed by the account!


## Example

In this example, we'll create a payment transaction with a sequence number equal to the next plus one, in order to get the *hash* of this transaction.

```elixir
# source account's keypair
public_key = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
secret_key = "SECRET_SEED"

# destination public key
destination_pk = "GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW"

# 1. set the source account
source_account = Stellar.TxBuild.Account.new(public_key)

# 2. set the next sequence number + 1 for the source account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(pk1)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num + 1)

# 3. build the payment operation
payment_op =
  Stellar.TxBuild.Payment.new(
    destination: destination_pk,
    asset: :native,
    amount: 25
  )

# notice that the transaction is not signed
{:ok, tx_build} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number, time_bounds: time_bounds)
  |> Stellar.TxBuild.add_operation(payment_op)

# 5. get the transaction hash
payment_tx_hash = Stellar.TxBuild.hash(tx_build) # example: "0c771e0ac49dc7798097e222289fd350278bc4aef5cf82ae6fb39b1d869e18a2"

# 6. get the transaction envelope
{:ok, payment_tx_envelope} = Stellar.TxBuild.envelope(tx_build)
```

Then, we'll add the *hash* as a signer on the account (via `SetOptions` operation), and submit the transaction to the network.

```elixir
# 8. set the next sequence number (not adding 1 this time)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 9. build the set options operation setting the trasaction hash as a signer with weight 1
set_options_op =
  Stellar.TxBuild.SetOptions.new(
    signer: [
      pre_auth_tx: payment_tx_hash,
      weight: 1
    ]
  )

# 10. build the signature for the set options transaction
signature = Stellar.TxBuild.Signature.new(ed25519: secret_key)

# 11. submit the set options transaction to Horizon
{:ok, set_options_tx_envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(set_options_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_set_options_tx} = Stellar.Horizon.Transactions.create(set_options_tx_envelope)
```

Finally, we'll submit the payment transaction, which will be valid because the account has already signed it since it is a **pre-authorized transaction**.

```elixir
{:ok, submitted_payment_tx} = Stellar.Horizon.Transactions.create(payment_tx_envelope)
```
