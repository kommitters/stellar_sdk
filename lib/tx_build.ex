defmodule Stellar.TxBuild do
  @moduledoc """
  Specifies an API to build Stellar transactions.
  """

  @behaviour Stellar.TxBuild.Spec

  alias Stellar.TxBuild.{Signature, Transaction, TransactionEnvelope}

  @type tx :: Transaction.t()
  @type signatures :: Signature.t() | list(Signature.t())
  @type tx_envelope :: TransactionEnvelope.t() | nil

  @type t :: %__MODULE__{
          tx: tx(),
          signatures: signatures(),
          tx_envelope: tx_envelope()
        }

  defstruct [:tx, :signatures, :tx_envelope]

  @impl true
  def new(account, opts \\ []), do: impl().new(account, opts)

  @impl true
  def add_memo(tx, memo), do: impl().add_memo(tx, memo)

  @impl true
  def set_timeout(tx, time_bounds), do: impl().set_timeout(tx, time_bounds)

  @impl true
  def add_operation(tx, operations), do: impl().add_operation(tx, operations)

  @impl true
  def sign(tx, signatures), do: impl().sign(tx, signatures)

  @impl true
  def build(tx), do: impl().build(tx)

  @impl true
  def envelope(tx), do: impl().envelope(tx)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :tx_build_impl, Stellar.TxBuild.Default)
  end
end
