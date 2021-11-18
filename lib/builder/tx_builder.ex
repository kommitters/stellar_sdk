defmodule Stellar.TxBuilder do
  @moduledoc """
  Specifies the API for bulding Stellar transactions.
  """
  alias Stellar.TxBuilder
  alias Stellar.Builder.Structs.{Account, Memo, TxBuild}

  @behaviour TxBuilder.Spec

  @impl true
  def new(%Account{} = account, opts \\ []), do: impl().new(account, opts)

  @impl true
  def add_memo(%TxBuild{} = builder, %Memo{} = memo), do: impl().add_memo(builder, memo)

  @impl true
  def set_timeout(%TxBuild{} = builder, timeout), do: impl().set_timeout(builder, timeout)

  @impl true
  def add_operation(%TxBuild{} = builder, operation), do: impl().add_operation(builder, operation)

  @impl true
  def sign(%TxBuild{} = builder, keypair), do: impl().sign(builder, keypair)

  @impl true
  def build(%TxBuild{} = builder), do: impl().build(builder)

  @impl true
  def to_base64(envelope_xdr), do: impl().to_base64(envelope_xdr)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :tx_builder, TxBuilder.Default)
  end
end
