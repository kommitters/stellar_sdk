defmodule Stellar.TxBuild.CannedTxBuildImpl do
  @moduledoc false

  @behaviour Stellar.TxBuild.Spec

  @impl true
  def new(_account, _opts) do
    send(self(), {:new, "NEW_TX"})
    :ok
  end

  @impl true
  def add_memo(_tx, _memo) do
    send(self(), {:add_memo, "MEMO_ADDED"})
    :ok
  end

  @impl true
  def set_timeout(_tx, _time_bounds) do
    send(self(), {:set_timeout, "TIMEOUT_SET"})
    :ok
  end

  @impl true
  def add_operation(_tx, _operations) do
    send(self(), {:add_operation, "OP_ADDED"})
    :ok
  end

  @impl true
  def sign(_tx, _signatures) do
    send(self(), {:sign, "TX_SIGNED"})
    :ok
  end

  @impl true
  def build(_tx) do
    send(self(), {:build, "TX_CREATED"})
    :ok
  end

  @impl true
  def envelope(_tx) do
    send(self(), {:envelope, "TX_ENVELOPE_GENERATED"})
    :ok
  end
end

defmodule Stellar.TxBuildTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Account, CannedTxBuildImpl}
  alias Stellar.TxBuild.Default, as: TxBuild

  setup do
    Application.put_env(:stellar_sdk, :tx_build_impl, CannedTxBuildImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :tx_build_impl)
    end)
  end

  test "new/2" do
    Stellar.TxBuild.new(%Account{}, [])
    assert_receive({:new, "NEW_TX"})
  end

  test "add_memo/2" do
    Stellar.TxBuild.add_memo(%TxBuild{}, :memo)
    assert_receive({:add_memo, "MEMO_ADDED"})
  end

  test "set_timeout/1" do
    Stellar.TxBuild.set_timeout(%TxBuild{}, :timeout)
    assert_receive({:set_timeout, "TIMEOUT_SET"})
  end

  test "add_operation/1" do
    Stellar.TxBuild.add_operation(%TxBuild{}, :operation)
    assert_receive({:add_operation, "OP_ADDED"})
  end

  test "sign/2" do
    Stellar.TxBuild.sign(%TxBuild{}, :signature)
    assert_receive({:sign, "TX_SIGNED"})
  end

  test "build/1" do
    Stellar.TxBuild.build(%TxBuild{})
    assert_receive({:build, "TX_CREATED"})
  end

  test "envelope/1" do
    Stellar.TxBuild.envelope(%TxBuild{})
    assert_receive({:envelope, "TX_ENVELOPE_GENERATED"})
  end
end
