defmodule Stellar.Horizon.FakeTransaction do
  @moduledoc false

  defstruct [:id, :source_account, :fee, :created_at, :operation, :balances]
end

defmodule Stellar.Horizon.FakeOperation do
  @moduledoc false

  @behaviour Stellar.Horizon.Resource

  defstruct [:id, :hash, :fee, :balance]

  @impl true
  def new(attrs \\ %{}, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{
      id: Map.get(attrs, :id),
      hash: Map.get(attrs, :hash),
      balance: Map.get(attrs, :balance)
    }
  end
end

defmodule Stellar.Horizon.MappingTest do
  use ExUnit.Case

  alias Stellar.Horizon.{Mapping, FakeTransaction, FakeOperation}

  setup do
    %{
      id: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
      source_account: "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC",
      created_at: "2020-01-27T22:13:17Z",
      fee: "100",
      resource: %FakeTransaction{}
    }
  end

  test "build/2", %{resource: resource, id: id, source_account: source_account} do
    attrs = %{id: id, source_account: source_account}
    %FakeTransaction{id: ^id, source_account: ^source_account} = Mapping.build(resource, attrs)
  end

  test "build/2 empty_attrs", %{resource: resource} do
    %FakeTransaction{id: nil, source_account: nil, created_at: nil} = Mapping.build(resource, %{})
  end

  test "build/2 extra_attrs", %{resource: resource, id: id, source_account: source_account} do
    attrs = %{id: id, source_account: source_account, memo: "none"}
    %FakeTransaction{id: ^id, source_account: ^source_account} = Mapping.build(resource, attrs)
  end

  test "parse/2", %{resource: resource, id: id, created_at: created_at, fee: fee} do
    attrs = %{id: id, fee: fee, created_at: created_at}

    %FakeTransaction{id: ^id, fee: 100, created_at: ~U[2020-01-27 22:13:17Z]} =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(fee: :integer, created_at: :date_time)
  end

  test "parse/2 iso8601_date_time", %{resource: resource} do
    %FakeTransaction{created_at: ~U[2020-01-27 22:13:17Z]} =
      resource
      |> Mapping.build(%{created_at: "2020-01-27T22:13:17Z"})
      |> Mapping.parse(created_at: :date_time)
  end

  test "parse/2 bad_date_time_format", %{resource: resource} do
    %FakeTransaction{created_at: "27-01-2020"} =
      resource
      |> Mapping.build(%{created_at: "27-01-2020"})
      |> Mapping.parse(created_at: :date_time)
  end

  test "parse/2 integer", %{resource: resource} do
    %FakeTransaction{fee: 100} =
      resource
      |> Mapping.build(%{fee: "100"})
      |> Mapping.parse(fee: :integer)
  end

  test "parse/2 float", %{resource: resource} do
    %FakeTransaction{fee: 100.15} =
      resource
      |> Mapping.build(%{fee: "100.15"})
      |> Mapping.parse(fee: :float)
  end

  test "parse/2 map", %{resource: resource} do
    %FakeTransaction{fee: %{amount: 100.15}} =
      resource
      |> Mapping.build(%{fee: %{amount: "100.15"}})
      |> Mapping.parse(fee: {:map, [amount: :float]})
  end

  test "parse/2 list_of_maps", %{resource: resource} do
    %FakeTransaction{balances: [%{amount: 100.010}, %{amount: 200.15}]} =
      resource
      |> Mapping.build(%{balances: [%{amount: "100.010"}, %{amount: "200.15"}]})
      |> Mapping.parse(balances: {:list, :map, [amount: :float]})
  end

  test "parse/2 struct", %{id: id, resource: resource} do
    %FakeTransaction{operation: %FakeOperation{}} =
      resource
      |> Mapping.build(%{operation: %{id: id, hash: id, balance: 100}})
      |> Mapping.parse(operation: {:struct, FakeOperation})
  end

  test "parse/2 list_of_structs", %{id: id, resource: resource} do
    raw_operations = [
      %{id: id, hash: id, balance: 100},
      %{id: id, hash: id, balance: 200}
    ]

    %FakeTransaction{operation: [%FakeOperation{balance: 100}, %FakeOperation{balance: 200}]} =
      resource
      |> Mapping.build(%{operation: raw_operations})
      |> Mapping.parse(operation: {:list, :struct, FakeOperation})
  end
end
