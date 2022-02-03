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
  def set_time_bounds(_tx, _time_bounds) do
    send(self(), {:set_time_bounds, "TIME_BOUNDS_SET"})
    :ok
  end

  @impl true
  def set_sequence_number(_tx, _seq_number) do
    send(self(), {:set_sequence_number, "SEQ_NUMBER"})
    :ok
  end

  @impl true
  def set_base_fee(_tx, _base_fee) do
    send(self(), {:set_base_fee, "BASE_FEE"})
    :ok
  end

  @impl true
  def add_operation(_tx, _operations) do
    send(self(), {:add_operation, "OP_ADDED"})
    :ok
  end

  @impl true
  def add_operations(_tx, _operations) do
    send(self(), {:add_operations, "OPS_ADDED"})
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

  alias Stellar.TxBuild
  alias Stellar.TxBuild.{Account, CannedTxBuildImpl}

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

  test "set_time_bounds/2" do
    Stellar.TxBuild.set_time_bounds(%TxBuild{}, :time_bounds)
    assert_receive({:set_time_bounds, "TIME_BOUNDS_SET"})
  end

  test "set_base_fee/2" do
    Stellar.TxBuild.set_base_fee(%TxBuild{}, :base_fee)
    assert_receive({:set_base_fee, "BASE_FEE"})
  end

  test "set_sequence_number/2" do
    Stellar.TxBuild.set_sequence_number(%TxBuild{}, :seq_number)
    assert_receive({:set_sequence_number, "SEQ_NUMBER"})
  end

  test "add_operation/2" do
    Stellar.TxBuild.add_operation(%TxBuild{}, :operation)
    assert_receive({:add_operation, "OP_ADDED"})
  end

  test "add_operations/2" do
    Stellar.TxBuild.add_operations(%TxBuild{}, [:op1, :op2])
    assert_receive({:add_operations, "OPS_ADDED"})
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
