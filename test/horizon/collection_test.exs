defmodule Stellar.Horizon.CollectionTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.{Collection, CollectionError, Transaction, Transactions}

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
    } = Collection.new(response, {Transaction, &Transactions.all/1})
  end

  test "error" do
    assert_raise CollectionError, "can't parse response as a collection", fn ->
      Collection.new(%{}, {Transaction, fn -> :ok end})
    end
  end

  test "pagination", %{response: response} do
    %Collection{prev: prev, next: next} = Collection.new(response, {Transaction, &{:ok, &1}})

    assert is_function(prev)
    assert is_function(next)
  end

  test "next", %{response: response} do
    %Collection{next: next} = Collection.new(response, {Transaction, &{:ok, &1}})
    {:ok, [cursor: "33736968114176", limit: "3", order: "asc"]} = next.()
  end

  test "prev", %{response: response} do
    %Collection{next: next} = Collection.new(response, {Transaction, &{:ok, &1}})
    {:ok, [cursor: "33736968114176", limit: "3", order: "asc"]} = next.()
  end
end
