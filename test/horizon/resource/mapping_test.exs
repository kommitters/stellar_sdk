defmodule Stellar.Horizon.Resource.FakeTransaction do
  @moduledoc false

  defstruct [:id, :source_account, :fee, :created_at]
end

defmodule Stellar.Horizon.Resource.MappingTest do
  use ExUnit.Case

  alias Stellar.Horizon.Resource.{Mapping, FakeTransaction}

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
end
