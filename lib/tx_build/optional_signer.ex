defmodule Stellar.TxBuild.OptionalSigner do
  @moduledoc """
  `OptionalSigner` struct definition.
  """
  alias StellarBase.XDR.OptionalSigner
  alias Stellar.TxBuild.Signer

  @behaviour Stellar.TxBuild.XDR

  @type signer :: Signer.t() | nil

  @type t :: %__MODULE__{signer: signer()}

  defstruct [:signer]

  @impl true
  def new(signer \\ nil, opts \\ [])

  def new(%Signer{} = signer, _opts) do
    %__MODULE__{signer: signer}
  end

  def new(nil, _opts), do: %__MODULE__{signer: nil}

  @impl true
  def to_xdr(%__MODULE__{signer: nil}), do: OptionalSigner.new()

  def to_xdr(%__MODULE__{signer: signer}) do
    signer
    |> Signer.to_xdr()
    |> OptionalSigner.new()
  end
end
