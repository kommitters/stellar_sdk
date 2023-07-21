defmodule Stellar.TxBuild.SorobanCredentials do
  @moduledoc """
  `SorobanCredentials` struct definition.
  """
  alias StellarBase.XDR.{SorobanCredentials, SorobanCredentialsType, Void}
  alias Stellar.TxBuild.SorobanAddressCredentials

  @behaviour Stellar.TxBuild.XDR

  @type value :: SorobanAddressCredentials.t() | nil
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type type :: :source_account | :address
  @type t :: %__MODULE__{type: type(), value: value()}

  defstruct [:type, :value]

  @allowed_types ~w(source_account address)a

  @impl true
  def new(value, opts \\ [])

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, value} <- validate_soroban_credentials({type, value}) do
      %__MODULE__{type: type, value: value}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_soroban_credential}

  @impl true
  def to_xdr(%__MODULE__{type: :source_account, value: nil}),
    do: SorobanCredentials.new(Void.new(), SorobanCredentialsType.new())

  def to_xdr(%__MODULE__{type: :address, value: value}) do
    type = SorobanCredentialsType.new(:SOROBAN_CREDENTIALS_ADDRESS)

    value
    |> SorobanAddressCredentials.to_xdr()
    |> SorobanCredentials.new(type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_soroban_credentials(tuple()) :: validation()
  defp validate_soroban_credentials({:source_account, nil}), do: {:ok, nil}

  defp validate_soroban_credentials({:address, %SorobanAddressCredentials{} = value}),
    do: {:ok, value}

  defp validate_soroban_credentials({type, _value}), do: {:error, :"invalid_#{type}"}
end
