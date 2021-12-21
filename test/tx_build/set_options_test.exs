defmodule Stellar.TxBuild.SetOptionsTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [set_options_xdr: 7]

  alias Stellar.TxBuild.{Flags, OptionalAccountID, OptionalFlags, OptionalSigner, OptionalString32, OptionalWeight, SetOptions, Signer, String32, Weight}

  setup do
    inflation_destination = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    clear_flags = []
    set_flags = [:required, :revocable, :inmutable, :clawback_enabled]
    master_weight = 1
    tresholds = [low: 1, med: 2, high: 3]
    home_domain = "stellar.org"

    signer = [
      pre_auth_tx: "f798b14cca436cb215073fec67219f1d13d051c4eff8adeed094a7ea807e66e4",
      weight: 1
    ]


    %{
      inflation_destination: inflation_destination,
      clear_flags: clear_flags,
      set_flags: set_flags,
      master_weight: master_weight,
      tresholds: tresholds,
      home_domain: home_domain,
      signer: signer,
      xdr:
        set_options_xdr(
          inflation_destination,
          clear_flags,
          set_flags,
          master_weight,
          tresholds,
          home_domain,
          signer
        )
    }
  end

  test "new/2", %{
    inflation_destination: inflation_destination,
    set_flags: set_flags,
    master_weight: master_weight,
    signer: signer
  } do
    inflation_destination_str = OptionalAccountID.new(inflation_destination)
    set_flags_str = set_flags |> Flags.new() |> OptionalFlags.new()
    master_weight_str = master_weight |> Weight.new() |> OptionalWeight.new()
    signer_str = signer |> Signer.new() |> OptionalSigner.new()

    %SetOptions{
      inflation_destination: ^inflation_destination_str,
      set_flags: ^set_flags_str,
      master_weight: ^master_weight_str,
      signer: ^signer_str
    } =
      SetOptions.new(
        inflation_destination: inflation_destination,
        set_flags: set_flags,
        master_weight: master_weight,
        signer: signer
      )
  end

  test "new/2 set_tresholds", %{
    tresholds: [low: low_threshold, med: med_threshold, high: high_threshold]
  } do
    low_threshold_str = low_threshold |> Weight.new() |> OptionalWeight.new()
    med_threshold_str = med_threshold |> Weight.new() |> OptionalWeight.new()
    high_threshold_str = high_threshold |> Weight.new() |> OptionalWeight.new()

    %SetOptions{
      low_threshold: ^low_threshold_str,
      medium_threshold: ^med_threshold_str,
      high_threshold: ^high_threshold_str
    } =
      SetOptions.new(
        low_threshold: low_threshold,
        medium_threshold: med_threshold,
        high_threshold: high_threshold
      )
  end

  test "new/2 set_home_domain", %{home_domain: home_domain} do
    home_domain_str = home_domain |> String32.new() |> OptionalString32.new()

    %SetOptions{home_domain: ^home_domain_str} = SetOptions.new(home_domain: home_domain)
  end

  test "new/2 with_invalid_destination" do
    {:error, [inflation_destination: :invalid_account_id]} =
      SetOptions.new(inflation_destination: "ABC", master_weight: 1)
  end

  test "new/2 with_invalid_flags" do
    {:error, [set_flags: :invalid_flags]} = SetOptions.new(set_flags: :auth)
  end

  test "new/2 with_invalid_weight" do
    {:error, [master_weight: :invalid_weight]} = SetOptions.new(master_weight: "2")
  end

  test "new/2 with_invalid_home_domain" do
    {:error, [home_domain: :invalid_string]} = SetOptions.new(home_domain: 123)
  end

  test "new/2 with_invalid_signer" do
    {:error, [signer: :invalid_signer_type]} = SetOptions.new(signer: [hash: "HASH", weight: 2])
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = SetOptions.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    inflation_destination: inflation_destination,
    clear_flags: clear_flags,
    set_flags: set_flags,
    master_weight: master_weight,
    tresholds: tresholds,
    home_domain: home_domain,
    signer: signer
  } do

    set_options =
      SetOptions.new(
        inflation_destination: inflation_destination,
        clear_flags: clear_flags,
        set_flags: set_flags,
        master_weight: master_weight,
        low_threshold: tresholds[:low],
        medium_threshold: tresholds[:med],
        high_threshold: tresholds[:high],
        home_domain: home_domain,
        signer: signer
      )

    ^xdr = SetOptions.to_xdr(set_options)
  end
end
