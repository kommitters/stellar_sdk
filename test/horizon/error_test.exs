defmodule Stellar.Horizon.ErrorTest do
  use ExUnit.Case

  alias Stellar.Horizon.Error

  test "new/1" do
    error_body = %{
      type: "Horizon error",
      title: "Error",
      status: 500,
      detail: "An error has ocurred"
    }

    %Stellar.Horizon.Error{
      detail: "An error has ocurred",
      extras: nil,
      status_code: 500,
      title: "Error",
      type: "Horizon error"
    } = Error.new({:horizon, error_body})
  end

  test "new/1 with_extras" do
    error_body = %{
      type: "Horizon error",
      title: "Error",
      status: 500,
      detail: "An error has ocurred",
      extras: %{transaction: "Malformed transaction"}
    }

    %Stellar.Horizon.Error{
      detail: "An error has ocurred",
      extras: %{transaction: "Malformed transaction"},
      status_code: 500,
      title: "Error",
      type: "Horizon error"
    } = Error.new({:horizon, error_body})
  end

  test "new/1 network" do
    %Error{
      detail: "An error occurred while making the network request: :nxdomain",
      extras: %{},
      status_code: :network_error,
      title: "Network error",
      type: nil
    } = Error.new({:network, :nxdomain})
  end
end
