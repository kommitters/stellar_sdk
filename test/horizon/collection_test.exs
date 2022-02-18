defmodule Stellar.Horizon.CollectionTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.{Collection, CollectionError, Transaction}

  describe "new/1" do
    setup do
      json_body = Horizon.fixture("transactions")
      response = Jason.decode!(json_body, keys: :atoms)

      %{response: response}
    end

    test "success", %{response: response} do
      %Collection{
        records: [
          %Transaction{hash: "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889"},
          %Transaction{hash: "2db4b22ca018119c5027a80578813ffcf582cda4aa9e31cd92b43cf1bda4fc5a"},
          _tx
        ]
      } = Collection.new({Transaction, response})
    end

    test "error" do
      assert_raise CollectionError, "can't parse response as a collection", fn ->
        Collection.new({Transaction, %{}})
      end
    end

    test "pagination", %{response: response} do
      %Collection{
        prev:
          "https://horizon.stellar.org/transactions?cursor=12884905984\u0026limit=3\u0026order=desc",
        next:
          "https://horizon.stellar.org/transactions?cursor=33736968114176\u0026limit=3\u0026order=asc"
      } = Collection.new({Transaction, response})
    end
  end
end
