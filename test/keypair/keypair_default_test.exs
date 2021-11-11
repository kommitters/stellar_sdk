defmodule Stellar.KeyPair.DefaultTest do
  use ExUnit.Case

  alias Stellar.KeyPair.Default

  setup do
    %{
      public_key: "GDAO7ET7LDTO5UCMMRYPE2M7YRRK3LQQD425L64WWTKRERVF3AMOOIWG",
      secret: "SDP6MYCODMMYJXWWLY5GSQJUZOGDV672LFCKNGJYLSYVXTGWVJGJHBJT"
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
end
