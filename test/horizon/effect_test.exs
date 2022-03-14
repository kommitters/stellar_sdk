defmodule Stellar.Horizon.EffectTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Effect

  setup do
    json_body = Horizon.fixture("effect")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Effect{
      id: "0000000549755817992-0000000001",
      paging_token: "549755817992-1",
      account: "GCNP7JE6KR5CKHMVVFTZJUSP7ALAXWP62SK6IMIY4IF3JCHEZKBJKDZF",
      type: "trustline_created",
      type_i: 20,
      attributes: %{
        asset_code: "TEST",
        asset_issuer: "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB",
        asset_type: "credit_alphanum4",
        limit: "922337203685.4775807"
      },
      created_at: ~U[2021-12-15 09:38:34Z]
    } = Effect.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Effect{
      id: nil,
      paging_token: nil,
      account: nil,
      type: nil,
      type_i: nil,
      attributes: %{},
      created_at: nil
    } = Effect.new(%{})
  end
end
