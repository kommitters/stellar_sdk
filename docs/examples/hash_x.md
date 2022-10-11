# Hash(x) Signer

Adding a signature of type **hash(x)** allows anyone who knows **x** to sign the transaction. Of course, once it's used, it is revealed to the world, so it can be used by anyone.


**How can you generate `x` and `hash(x)`?**

Create a random 32-byte (256-bit) value, which we call `x` or `preimage`. The SHA256 hash of that value `x` can be added as a signer of type `hash(x)`. Then in order to authorize a transaction, `x` is added as one of the signatures of the transaction.

```elixir
raw_preimage = :crypto.strong_rand_bytes(32)
preimage = Base.encode16(raw_preimage, case: :lower)

hash_x = :sha256 |> :crypto.hash(raw_preimage) |> Base.encode16(case: :lower)
```

---

For a **raw preimage** like this:
```elixir
<<37, 115, 193, 39, 204, 224, 190, 248, 12, 251, 213, 33, 46, 170, 236, 55, 88, 33, 172, 109, 176, 93, 53, 67, 186, 198, 71, 19, 14, 107, 216, 223>>
```
The **preimage** in hexadecimal format will be:  `2573c127cce0bef80cfbd5212eaaec375821ac6db05d3543bac647130e6bd8df`

And the **hash(x)** will be: `819a87db1e47ae26b9b7716a6a4eb01bb3c16aeb82b83548dec81948b76e4f34`.

Then, the **hash(x)** is added as signer and the **preimage** is added as signature for a transaction.


## Set a Hash(x) Signer

```elixir
# source account's keypair
public_key = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
secret_key = "SECRET_SEED"

# hex-encoded hash(x)
hash_x = "819a87db1e47ae26b9b7716a6a4eb01bb3c16aeb82b83548dec81948b76e4f34"

# 1. set the source account
source_account = Stellar.TxBuild.Account.new(public_key)

# 2. set the next sequence number for the source account
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(public_key)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# 3. build the set_options operation setting the hash(x) as a signer with weight 1
set_options_op = Stellar.TxBuild.SetOptions.new(signer: [hash_x: hash_x, weight: 1])

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

## Send a payment using the preimage `x` as a signature

```elixir
# founder keypair
payer_pk = "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ"
payer_sk = "SECRET_SEED"

# destination public key
destination_pk = "GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW"

# hex-encoded preimage (x)
preimage = "2573c127cce0bef80cfbd5212eaaec375821ac6db05d3543bac647130e6bd8df"

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
