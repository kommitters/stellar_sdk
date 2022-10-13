# Hash(x) Signature

## Context

You can add the **hash of any value** as the signer to an account. Then, the **value itself** can be used as a signature. Of course, once it's used, it is revealed to the world, so it can be used by anyone.

## Guide

This guide will show you how to create a hash signature and use it to sign a transaction.

A payment transaction will be used as an example, but the same process can be applied to any transaction!

### 1. Prerequisites

You need to have two funded accounts.

- For the first one: you will need to know the public and secret key. This account will send the payment.
- For the second one: you will need to know the public key. This account will receive the payment.

```elixir
# payer's keypair
payer_pk = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
payer_sk = "SECRET_SEED"

# destination public key
destination_pk = "GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW"
```

### 2. Generate `x` and `hash(x)`

You need to create a random 32-byte (256-bit) value, which we call `x` or `preimage`; and the SHA256 hash of `x`, which we call `hash(x)`.

Those values can be generated using the following code:

```elixir
raw_preimage = :crypto.strong_rand_bytes(32)
preimage = Base.encode16(raw_preimage, case: :lower)

hash_x = :sha256 |> :crypto.hash(raw_preimage) |> Base.encode16(case: :lower)
```

For instance, the values of `preimage` and `hash_x` can be:

```elixir
raw_preimage = <<37, 115, 193, 39, 204, 224, 190, 248, 12, 251, 213, 33, 46, 170, 236, 55, 88, 33, 172, 109, 176, 93, 53, 67, 186, 198, 71, 19, 14, 107, 216, 223>>
preimage = "2573c127cce0bef80cfbd5212eaaec375821ac6db05d3543bac647130e6bd8df"

hash_x = "819a87db1e47ae26b9b7716a6a4eb01bb3c16aeb82b83548dec81948b76e4f34"
```

Notice that `preimage` and `hash_x` are both hexadecimal encoded.

### 3. Add `hash(x)` as a signer to the account

In this step, the SHA256 hash is added as a signer to the account.

Remember that it is stored in the `hash_x` variable.

Setting the signer is done via the `Stellar.TxBuild.SetOptions` operation, see the code below:

```elixir
# 1. set the source account
source_account = Stellar.TxBuild.Account.new(payer_pk)

# 2. set the next sequence number for the source account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(payer_pk)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the set_options operation setting the hash(x) as a signer with weight 1
set_options_op = Stellar.TxBuild.SetOptions.new(signer: [hash_x: hash_x, weight: 1])

# 4. build the tx signature
signature = Stellar.TxBuild.Signature.new(ed25519: payer_sk)

# 5. submit the transaction to Horizon
{:ok, envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(set_options_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(envelope)
```

The transaction is submitted! Now, the `hash(x)` is a signer of the account.

### 4. Send the payment using `preimage` as a signature

Since the `hash(x)` is a signer of the account, then you can submit a transaction using the `preimage` as a signature.

Let's send a payment to the destination account!

```elixir
# 1. set the founder account
source_account = Stellar.TxBuild.Account.new(payer_pk)

# 2. set the next sequence number for the founder account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(payer_pk)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the payment operation
payment_op =
  Stellar.TxBuild.Payment.new(
    destination: destination_pk,
    asset: :native,
    amount: 25
  )

# 4. build the tx signature by providing the hex-encoded preimage
signature = Stellar.TxBuild.Signature.new(hash_x: preimage)

# 5. submit the transaction to Horizon
{:ok, envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(payment_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(envelope)
```

> 👍 That's it!
>
> The payment was sent using the `preimage` as a signature!
