# Ed25519 Signed Payload Signature

The `Ed25519 Signed Payload` is a new signer type introduced in [CAP-40](https://github.com/stellar/stellar-protocol/blob/master/core/cap-0040.md).

You start with a keypair, `(pk, sk)` and a payload `P`. Then, you configure a "signed payload" signer with `(pk, P)`. This means that `Sign(sk, P)` is a valid transaction signature.

**How can you generate the payload?**

The payload `P` is a value of up to 32 bytes (256 bits).

You can generate `P` using the following code:

```elixir
# you can use a different byte size up to 32
raw_payload = :crypto.strong_rand_bytes(32)
payload = Base.encode16(raw_payload, case: :lower)
```

You need to encode the payload in hexadecimal format to be able to use it in the Elixir Stellar SDK.

---

For a raw payload like this:
```elixir
<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32>>
```
, the payload `P` in hexadecimal format will be
`0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20`.

## Set an Ed25519 Signed Payload Signer

```elixir
# source account's keypair
public_key = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
secret_key = "SECRET_SEED"

# hex-encoded payload
payload = "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"

# 1. set the source account
source_account = Stellar.TxBuild.Account.new(public_key)

# 2. set the next sequence number for the source account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(public_key)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the set_options operation setting the ed25519 signed payload as a signer with weight 1
set_options_op =
  Stellar.TxBuild.SetOptions.new(
    signer: [
      signed_payload: [ed25519: public_key, payload: payload],
      weight: 1
    ]
  )

# 4. build the tx signature
signature = Stellar.TxBuild.Signature.new(ed25519: secret_key)

# 5. submit the transaction to Horizon
{:ok, envelope} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(set_options_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(envelope)
```

## Send a payment using the Ed25519 Signed Payload signature

```elixir
# founder keypair
payer_pk = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
payer_sk = "SECRET_SEED"

# destination public key
destination_pk = "GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW"

# hex-encoded payload
payload = "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"

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

{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(envelope)
```
