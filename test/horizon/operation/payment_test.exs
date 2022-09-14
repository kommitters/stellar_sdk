defmodule Stellar.Horizon.Operation.PaymentTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.Payment

  setup do
    %{
      attrs: %{
        asset_type: "credit_alphanum4",
        asset_code: "NGNT",
        asset_issuer: "GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD",
        from: "GCAXBKU3AKYJPLQ6PEJ6L47KOATCYCBJ2NFRGAK7FUUA2DCEUC265SU2",
        to: "GC2QCKFI3DOBEYVBONPVNA2PMLU225IKKI6XPENMWR2CTWSFBAOU7T34",
        amount: "5.0267500000"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{asset_type: asset_type, asset_code: asset_code, from: from, to: to, amount: amount} =
        attrs
  } do
    %Payment{
      asset_type: ^asset_type,
      asset_code: ^asset_code,
      from: ^from,
      to: ^to,
      amount: ^amount
    } = Payment.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Payment{asset_type: nil, asset_code: nil, from: nil, to: nil, amount: nil} = Payment.new(%{})
  end
end
