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
  def set_time_bounds(tx, time_bounds), do: impl().set_time_bounds(tx, time_bounds)

  @impl true
  def set_preconditions(tx, preconditions), do: impl().set_preconditions(tx, preconditions)

  @impl true
  def set_base_fee(tx, timeout), do: impl().set_base_fee(tx, timeout)

  @impl true
  def set_sequence_number(tx, sequence_number),
    do: impl().set_sequence_number(tx, sequence_number)

  @impl true
  def add_operation(tx, operation), do: impl().add_operation(tx, operation)

  @impl true
  def add_operations(tx, operations), do: impl().add_operations(tx, operations)

  @impl true
  def sign(tx, signatures), do: impl().sign(tx, signatures)

  @impl true
  def build(tx), do: impl().build(tx)

  @impl true
  def envelope(tx), do: impl().envelope(tx)

  @impl true
  def sign_envelope(base64_envelope, signatures),
    do: impl().sign_envelope(base64_envelope, signatures)

  @impl true
  def hash(tx), do: impl().hash(tx)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :tx_build_impl, Stellar.TxBuild.Default)
  end
end
