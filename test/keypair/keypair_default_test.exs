defmodule Stellar.KeyPair.DefaultTest do
  use ExUnit.Case

  alias Stellar.KeyPair.Default

  setup do
    %{
      public_key: "GDAO7ET7LDTO5UCMMRYPE2M7YRRK3LQQD425L64WWTKRERVF3AMOOIWG",
      secret: "SDP6MYCODMMYJXWWLY5GSQJUZOGDV672LFCKNGJYLSYVXTGWVJGJHBJT",
      encoded_public_key:
        <<192, 239, 146, 127, 88, 230, 238, 208, 76, 100, 112, 242, 105, 159, 196, 98, 173, 174,
          16, 31, 53, 213, 251, 150, 180, 213, 18, 70, 165, 216, 24, 231>>,
      encoded_secret:
        <<223, 230, 96, 78, 27, 25, 132, 222, 214, 94, 58, 105, 65, 52, 203, 140, 58, 251, 250,
          89, 68, 166, 153, 56, 92, 177, 91, 204, 214, 170, 76, 147>>,
      signature:
        <<215, 199, 186, 220, 150, 210, 229, 108, 54, 13, 160, 26, 38, 184, 120, 233, 253, 170,
          252, 68, 235, 166, 205, 2, 115, 76, 254, 20, 85, 1, 224, 106, 84, 196, 217, 38, 248,
          147, 151, 69, 212, 28, 97, 216, 105, 170, 173, 9, 38, 94, 9, 97, 78, 145, 138, 94, 245,
          145, 255, 26, 28, 9, 110, 10>>
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

  test "from_secret/1", %{public_key: public_key, secret: secret} do
    {^public_key, ^secret} = Default.from_secret(secret)
  end

  test "raw_ed25519_public_key/1", %{
    public_key: public_key,
    encoded_public_key: encoded_public_key
  } do
    ^encoded_public_key = Default.raw_ed25519_public_key(public_key)
  end

  test "raw_ed25519_secret/1", %{secret: secret, encoded_secret: encoded_secret} do
    ^encoded_secret = Default.raw_ed25519_secret(secret)
  end

  test "sign/2", %{secret: secret, signature: signature} do
    ^signature = Default.sign(<<0, 0, 0, 0>>, secret)
  end

  test "sign/2 invalid_values", %{secret: secret} do
    {:error, :invalid_signature_payload} = Default.sign(nil, secret)
  end
end
