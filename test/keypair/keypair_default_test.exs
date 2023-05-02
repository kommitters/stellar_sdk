defmodule Stellar.KeyPair.DefaultTest do
  use ExUnit.Case

  alias Stellar.KeyPair.Default

  setup do
    %{
      public_key: "GDAO7ET7LDTO5UCMMRYPE2M7YRRK3LQQD425L64WWTKRERVF3AMOOIWG",
      secret: "SDP6MYCODMMYJXWWLY5GSQJUZOGDV672LFCKNGJYLSYVXTGWVJGJHBJT",
      pre_auth_tx: "TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B",
      sha256_hash: "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC",
      signed_payload:
        "PA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAQACAQDAQCQMBYIBEFAWDANBYHRAEISCMKBKFQXDAMRUGY4DUPB6IBZGM",
      contract: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
      encoded_public_key:
        <<192, 239, 146, 127, 88, 230, 238, 208, 76, 100, 112, 242, 105, 159, 196, 98, 173, 174,
          16, 31, 53, 213, 251, 150, 180, 213, 18, 70, 165, 216, 24, 231>>,
      encoded_secret:
        <<223, 230, 96, 78, 27, 25, 132, 222, 214, 94, 58, 105, 65, 52, 203, 140, 58, 251, 250,
          89, 68, 166, 153, 56, 92, 177, 91, 204, 214, 170, 76, 147>>,
      encoded_pre_auth_tx:
        <<170, 83, 38, 205, 9, 126, 182, 138, 252, 59, 73, 56, 31, 230, 190, 41, 122, 35, 34, 164,
          197, 158, 190, 244, 150, 118, 164, 216, 146, 173, 218, 44>>,
      encoded_sha256_hash:
        <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129, 248, 20,
          182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>,
      encoded_signed_payload:
        <<63, 12, 52, 191, 147, 173, 13, 153, 113, 208, 76, 204, 144, 247, 5, 81, 28, 131, 138,
          173, 151, 52, 164, 162, 251, 13, 122, 3, 252, 127, 232, 154, 0, 0, 0, 32, 1, 2, 3, 4, 5,
          6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          29, 30, 31, 32>>,
      encoded_contract:
        <<136, 199, 21, 221, 153, 62, 83, 56, 9, 112, 55, 17, 157, 226, 244, 109, 177, 22, 241,
          170, 12, 226, 193, 229, 39, 50, 103, 40, 26, 129, 1, 237>>,
      signature:
        <<215, 199, 186, 220, 150, 210, 229, 108, 54, 13, 160, 26, 38, 184, 120, 233, 253, 170,
          252, 68, 235, 166, 205, 2, 115, 76, 254, 20, 85, 1, 224, 106, 84, 196, 217, 38, 248,
          147, 151, 69, 212, 28, 97, 216, 105, 170, 173, 9, 38, 94, 9, 97, 78, 145, 138, 94, 245,
          145, 255, 26, 28, 9, 110, 10>>,
      payload:
        <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
          25, 26, 27, 28, 29, 30, 31, 32>>
    }
  end

  test "random/0 byte_size" do
    {public_key, secret} = Default.random()

    56 = byte_size(public_key)
    56 = byte_size(secret)
  end

  test "random/0 byte_version" do
    {public_key, secret} = Default.random()

    assert String.starts_with?(public_key, "G")
    assert String.starts_with?(secret, "S")
  end

  test "from_secret_seed/1", %{public_key: public_key, secret: secret} do
    {^public_key, ^secret} = Default.from_secret_seed(secret)
  end

  test "raw_public_key/1", %{
    public_key: public_key,
    encoded_public_key: encoded_public_key
  } do
    ^encoded_public_key = Default.raw_public_key(public_key)
  end

  test "raw_secret_seed/1", %{secret: secret, encoded_secret: encoded_secret} do
    ^encoded_secret = Default.raw_secret_seed(secret)
  end

  test "raw_pre_auth_tx/1", %{pre_auth_tx: pre_auth_tx, encoded_pre_auth_tx: encoded_pre_auth_tx} do
    ^encoded_pre_auth_tx = Default.raw_pre_auth_tx(pre_auth_tx)
  end

  test "raw_sha256_hash/1", %{sha256_hash: sha256_hash, encoded_sha256_hash: encoded_sha256_hash} do
    ^encoded_sha256_hash = Default.raw_sha256_hash(sha256_hash)
  end

  test "raw_signed_payload/1", %{
    signed_payload: signed_payload,
    encoded_signed_payload: encoded_signed_payload
  } do
    ^encoded_signed_payload = Default.raw_signed_payload(signed_payload)
  end

  test "raw_contract/1", %{
    contract: contract,
    encoded_contract: encoded_contract
  } do
    ^encoded_contract = Default.raw_contract(contract)
  end

  test "sign/2", %{secret: secret, signature: signature} do
    ^signature = Default.sign(<<0, 0, 0, 0>>, secret)
  end

  test "sign/2 invalid_values", %{secret: secret} do
    {:error, :invalid_signature_payload} = Default.sign(nil, secret)
  end

  test "valid_signature?/3 with valid signature", %{
    public_key: public_key,
    signature: signed_payload
  } do
    true = Default.valid_signature?(<<0, 0, 0, 0>>, signed_payload, public_key)
  end

  test "valid_signature?/3 with invalid signature", %{
    public_key: public_key,
    signature: signed_payload
  } do
    false = Default.valid_signature?(<<0, 0, 0, 1>>, signed_payload, public_key)
  end

  test "validate_public_key/1", %{public_key: public_key} do
    :ok = Default.validate_public_key(public_key)
  end

  test "validate_public_key/1 invalid_key" do
    {:error, :invalid_ed25519_public_key} = Default.validate_public_key("ABC")
  end

  test "validate_secret_seed/1", %{secret: secret} do
    :ok = Default.validate_secret_seed(secret)
  end

  test "validate_secret_seed/1 invalid_secret" do
    {:error, :invalid_ed25519_secret_seed} = Default.validate_secret_seed("ABC")
  end

  test "validate_pre_auth_tx/1", %{pre_auth_tx: pre_auth_tx} do
    :ok = Default.validate_pre_auth_tx(pre_auth_tx)
  end

  test "validate_pre_auth_tx/1 invalid_pre_auth_tx" do
    {:error, :invalid_pre_auth_tx} = Default.validate_pre_auth_tx("GCA")
  end

  test "validate_sha256_hash/1", %{sha256_hash: sha256_hash} do
    :ok = Default.validate_sha256_hash(sha256_hash)
  end

  test "validate_sha256_hash/1 invalid_sha256_hash" do
    {:error, :invalid_sha256_hash} = Default.validate_sha256_hash("GCA")
  end

  test "validate_signed_payload/1", %{signed_payload: signed_payload} do
    :ok = Default.validate_signed_payload(signed_payload)
  end

  test "validate_signed_payload/1 invalid_signed_payload" do
    {:error, :invalid_signed_payload} = Default.validate_signed_payload("GCA")
  end

  test "validate_contract/1", %{contract: contract} do
    :ok = Default.validate_contract(contract)
  end

  test "validate_contract/1 invalid_contract" do
    {:error, :invalid_contract} = Default.validate_contract("GCA")
  end

  test "signature_hint_for_signed_payload/2 payload with more than 4 bytes", %{
    encoded_public_key: encoded_public_key,
    payload: payload
  } do
    <<184, 198, 7, 199>> = Default.signature_hint_for_signed_payload(encoded_public_key, payload)
  end

  test "signature_hint_for_signed_payload/2 payload with less than 4 bytes", %{
    encoded_public_key: encoded_public_key
  } do
    <<187, 199, 56, 231>> =
      Default.signature_hint_for_signed_payload(encoded_public_key, <<30, 31, 32>>)
  end

  test "signature_hint_for_signed_payload/2 payload equal to 4 bytes", %{
    encoded_public_key: encoded_public_key
  } do
    <<184, 198, 7, 199>> =
      Default.signature_hint_for_signed_payload(encoded_public_key, <<29, 30, 31, 32>>)
  end
end
