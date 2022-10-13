# Pre-authorized Transaction Signature

## Context

You can actually sign a transaction "in advance", such that it might be valid in the future. To accomplish this, you add the *hash* of the transaction as a signer on the account. Then, when that transaction actually gets submitted to the network, it acts as if it was already signed by the account!


## Guide

This guide will lead you to send a payment without a signature, which is called a preauthorized transaction. But to achieve this, several steps are necessary, which will be detailed below.

### 1. Prerrequisites

You need to have two funded accounts.

- For the first one: you will need to know the public and secret key. This account will send the payment.
- For the second one: you will need to know the public key. This account will receive the payment.

```elixir
# payer's keypair
public_key = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
secret_key = "SECRET_SEED"

# destination public key
destination_pk = "GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW"
```

### 2. Create a future transaction

In order to create a pre-authorized transaction, you need to create a future transaction with the current sequence number + 2.


<!-- In this example, you'll create a payment transaction with a sequence number, in order to get the *hash* of this transaction. -->

```elixir
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

# notice that the transaction does not include a signature
tx_build =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(payment_op)

# 5. get the transaction hash
{:ok, payment_tx_hash} = Stellar.TxBuild.hash(tx_build) # example: "0c771e0ac49dc7798097e222289fd350278bc4aef5cf82ae6fb39b1d869e18a2"

# 6. get the transaction envelope
{:ok, payment_tx_envelope} = Stellar.TxBuild.envelope(tx_build)
```

From this step, you have the **hash** (`payment_tx_hash`) of the transaction, which is the value that you will need to add as a signer to the source account.

And you also have the **transaction envelope** (`payment_tx_envelope`), which is the value that you will need to submit to the network.

### 3. Add the transaction hash as a signer to the source account

In this step, you will add the transaction hash from the previous step as a signer to the source account.

This is done by using the `Stellar.TxBuild.SetOptions` operation.

This transaction needs to be signed and submitted to the network to add officially the transaction hash as a signer to the source account. This transaction will be signed with the payer's secret key.

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

### 4. Submit the payment transaction

Finally, you'll submit the payment transaction.

Since it was added as a signer, it is already pre-authorized and don't need to be signed.

You only need to submit the transaction envelope to the network. ✅

```elixir
{:ok, submitted_payment_tx} = Stellar.Horizon.Transactions.create(payment_tx_envelope)
```

Once this is submitted, the transaction will be removed from the account as a signer.



> 👍 That's it!
>
> You have successfully sent a payment without a signature, which is called a pre-authorized transaction.
