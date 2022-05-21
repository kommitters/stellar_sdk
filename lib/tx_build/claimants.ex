defmodule Stellar.TxBuild.Claimants do
  @moduledoc """
  `Claimants` struct definition.
  """
  alias Stellar.TxBuild.Claimant
  alias StellarBase.XDR.Claimants

  @behaviour Stellar.TxBuild.XDR

  @type claimants :: Claimant.t() | list(Claimant.t())
  @type error :: {:error, atom()}

  @type t :: %__MODULE__{claimants: list(Claimant.t())}

  defstruct [:claimants]

  @impl true
  def new(claimants \\ [], opts \\ [])

  def new(claimants, _opts) do
    build_path(%__MODULE__{claimants: []}, claimants)
  end

  @impl true
  def to_xdr(%__MODULE__{claimants: claimants}) do
    claimants
    |> Enum.map(&Claimant.to_xdr/1)
    |> Claimants.new()
  end

  defp build_path(%__MODULE__{} = path, []), do: path

  defp build_path(%__MODULE__{} = path, [claimant | claimants]) do
    case claimant do
      %Claimant{} = claimant ->
        path
        |> build_path(claimant)
        |> build_path(claimants)

      _error ->
        {:error, :invalid_claimant}
    end
  end

  defp build_path(%__MODULE__{claimants: claimants} = path, %Claimant{} = claimant) do
    %{path | claimants: claimants ++ [claimant]}
  end
end
