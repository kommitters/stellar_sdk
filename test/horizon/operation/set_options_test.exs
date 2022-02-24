defmodule Stellar.Horizon.Operation.SetOptionsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.SetOptions

  setup do
    %{
      attrs: %{
        signer_weight: 2,
        signer_key: "GCVLWV5B3L3YE6DSCCMHLCK7QIB365NYOLQLW3ZKHI5XINNMRLJ6YHVX",
        master_key_weight: 1,
        low_threshold: 0,
        med_threshold: 1,
        high_threshold: 2,
        home_domain: "www.stellar.org",
        set_flags: [1, 2],
        set_flags_s: ["AUTH_REQUIRED_FLAG", "AUTH_REVOCABLE_FLAG"]
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        signer_weight: signer_weight,
        signer_key: signer_key,
        master_key_weight: master_key_weight,
        low_threshold: low_threshold,
        med_threshold: med_threshold,
        high_threshold: high_threshold,
        home_domain: home_domain,
        set_flags: set_flags,
        set_flags_s: set_flags_s
      } = attrs
  } do
    %SetOptions{
      signer_weight: ^signer_weight,
      signer_key: ^signer_key,
      master_key_weight: ^master_key_weight,
      low_threshold: ^low_threshold,
      med_threshold: ^med_threshold,
      high_threshold: ^high_threshold,
      home_domain: ^home_domain,
      set_flags: ^set_flags,
      set_flags_s: ^set_flags_s
    } = SetOptions.new(attrs)
  end

  test "new/2 empty_attrs" do
    %SetOptions{
      signer_weight: nil,
      signer_key: nil,
      master_key_weight: nil,
      low_threshold: nil,
      med_threshold: nil,
      high_threshold: nil,
      home_domain: nil,
      set_flags: nil,
      set_flags_s: nil
    } = SetOptions.new(%{})
  end
end
