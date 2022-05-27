defmodule Stellar.TxBuild.Claimants do
  @moduledoc """
  `Claimants` struct definition.
  """
  alias Stellar.TxBuild.Claimant
  alias StellarBase.XDR.Claimants

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{claimants: list(Claimant.t())}
  @type validation :: t() | {:error, atom()}
  @type claimants :: Claimant.t() | list(Claimant.t())
  @type error :: {:error, atom()}

  defstruct [:claimants]

  @impl true
  def new(claimants \\ [], opts \\ [])

  def new(claimants, _opts) do
    validate_claimants(%__MODULE__{claimants: []}, claimants)
  end

  @impl true
  def to_xdr(%__MODULE__{claimants: claimants}) do
    claimants
    |> Enum.map(&Claimant.to_xdr/1)
    |> Claimants.new()
  end

  @spec validate_claimants(claimants :: t(), list :: claimants()) :: validation()
  defp validate_claimants(%__MODULE__{} = path, []), do: path

  defp validate_claimants(%__MODULE__{} = path, [claimant | claimants]) do
    case claimant do
      %Claimant{} = claimant ->
        path
        |> validate_claimants(claimant)
        |> validate_claimants(claimants)

      _error ->
        {:error, :invalid_claimant}
    end
  end

  defp validate_claimants(%__MODULE__{claimants: claimants} = path, %Claimant{} = claimant) do
    %{path | claimants: claimants ++ [claimant]}
  end
end
