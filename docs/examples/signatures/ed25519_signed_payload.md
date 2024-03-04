# Ed25519 Signed Payload Signature

## Context

The `Ed25519 Signed Payload` is a new signer type introduced in [CAP-40](https://github.com/stellar/stellar-protocol/blob/master/core/cap-0040.md).

You start with a keypair, `(pk, sk)` and a payload `P`. Then, you configure a "signed payload" signer with `(pk, P)`. This means that `Sign(sk, P)` is a valid transaction signature.

So basically, you should provide:

- **public key** and **payload** to establish the signer of type `ed25519_signed_payload`
- **secret key** and **payload** to sign a transaction using the `ed25519_signed_payload` signature

## Guide

This guide will explain in detail the process to establish a signer of type **Ed25519 Signed Payload** and use the signature of this type to send valid transactions to the network.

In this guide, we will use a payment transaction as an example, but the process is the same for any other transaction type.

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

### 2. Generate payload

The `payload` is a value of up to 32 bytes (256 bits).

You can generate the `payload` using the following code:

```elixir
# you can use a different byte size up to 32
payload = 32 |> :crypto.strong_rand_bytes() |> Base.encode16(case: :lower)
```

---

For example, for a raw payload of:
```elixir
<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32>>
```

Then, the `payload` will be:
```elixir
payload = "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"
```

Notice that `payload` is hexadecimal encoded and lowercase.

### 3. Establish signer

Now, you need to establish a signer of type `ed25519_signed_payload` using the `payload` and the public key of the account that will send the payment (`payer_pk`).

So here, you use the `Stellar.TxBuild.SetOptions` operation to set the signer and this transaction is signed just by the secret key of the payer (`payer_sk`).

```elixir
# 1. set the source account
source_account = Stellar.TxBuild.Account.new(payer_pk)

# 2. set the next sequence number for the source account
server = Stellar.Horizon.Server.testnet()
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(server, payer_pk)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the set_options operation setting the ed25519 signed payload as a signer with weight 1
set_options_op =
  Stellar.TxBuild.SetOptions.new(
    signer: [
      signed_payload: [ed25519: payer_pk, payload: payload],
      weight: 1
    ]
  )

# 4. build the tx signature
signature = Stellar.TxBuild.Signature.new(ed25519: payer_sk)

# 5. submit the transaction to Horizon
{:ok, envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(set_options_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(server, envelope)
```

### 4. Send a payment using the Ed25519 Signed Payload signature

Once you have established the signer, you can use the `payload` and the secret key of the payer (`payer_sk`) to sign the transaction and send the payment.

```elixir
# 1. set the founder account
source_account = Stellar.TxBuild.Account.new(payer_pk)

# 2. set the next sequence number for the founder account
server = Stellar.Horizon.Server.testnet()
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(server, payer_pk)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the payment operation
payment_op =
  Stellar.TxBuild.Payment.new(
    destination: destination_pk,
    asset: :native,
    amount: 25
  )

# 4. build the tx signature with a signed payload
#    by providing the hex-encoded payload, and the secret key
signature = Stellar.TxBuild.Signature.new(signed_payload: [payload: payload, ed25519: payer_sk])

# 5. submit the transaction to Horizon
{:ok, envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(payment_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(server, envelope)
```

> 👍 That's it!
>
> The payment was sent using the **Ed25519 Signed Payload** as a signature!
