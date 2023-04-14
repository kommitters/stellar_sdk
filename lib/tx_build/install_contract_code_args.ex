defmodule Stellar.TxBuild.InstallContractCodeArgs do
  @moduledoc """
    `InstallContractCodeArgs` struct definition.
  """

  alias StellarBase.XDR.{InstallContractCodeArgs, VariableOpaque256000}

  @behaviour Stellar.TxBuild.XDR

  @type code :: VariableOpaque256000.t()

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          code: binary()
        }

  defstruct [:code]

  @impl true
  def new(args, opts \\ [])

  def new(code, _opts)
      when is_binary(code) do
    %__MODULE__{
      code: code
    }
  end

  def new(_args, _opts), do: {:error, :invalid_install_contract_code_args}

  @impl true
  def to_xdr(%__MODULE__{
        code: code
      }) do
    code
    |> VariableOpaque256000.new()
    |> InstallContractCodeArgs.new()
  end

  def to_xdr(_struct), do: {:error, :invalid_struct_install_contract_code_args}
end
