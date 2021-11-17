defmodule Stellar.Builder.Structs.Operations do
  @moduledoc """
  `Operations` struct definition.
  """
  alias StellarBase.XDR.Operations

  @type t :: %__MODULE__{operations: list()}

  defstruct [:operations]

  @spec new(operations :: list()) :: t()
  def new(operations \\ []) do
    %__MODULE__{operations: operations}
  end

  @spec new(operations :: t()) :: Operations.t()
  def to_xdr(%__MODULE__{operations: operations}) do
    Operations.new(operations)
  end
end
