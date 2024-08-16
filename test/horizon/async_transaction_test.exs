defmodule Stellar.Horizon.AsyncTransactionTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon

  alias Stellar.Horizon.{
    AsyncTransaction
  }

  setup do
    json_body = Horizon.fixture("async_transaction")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %AsyncTransaction{
      hash: "12958c37b341802a19ddada4c2a56b453a9cba728b2eefdfbc0b622e37379222",
      tx_status: "PENDING"
    } = AsyncTransaction.new(attrs)
  end

  test "new/2 empty_attrs" do
    %AsyncTransaction{
      hash: nil,
      tx_status: nil
    } = AsyncTransaction.new(%{})
  end
end
