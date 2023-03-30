defmodule Stellar.TxBuild.Footprint do
  @moduledoc """
  `Footprint` struct definition.
  """

  alias Stellar.TxBuild.LedgerKey

  alias StellarBase.XDR.{LedgerKeyList, LedgerFootprint}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          read_only: list(LedgerKey.t()),
          read_write: list(LedgerKey.t())
        }

  defstruct [:read_only, :read_write]

  @impl true
  def new(args \\ [], opts \\ [])

  def new(args, _opts) when is_list(args) do
    read_only = Keyword.get(args, :read_only, [])
    read_write = Keyword.get(args, :read_write, [])

    %__MODULE__{
      read_only: read_only,
      read_write: read_write
    }
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{read_only: read_only, read_write: read_write}) do
    read_only_list = LedgerKeyList.new(read_only)
    read_write_list = LedgerKeyList.new(read_write)

    LedgerFootprint.new(read_only_list, read_write_list)
  end
end
