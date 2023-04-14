defmodule Stellar.TxBuild.InstallContractCodeArgsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.InstallContractCodeArgs, as: TxInstallContractCodeArgs

  alias StellarBase.XDR.{InstallContractCodeArgs, VariableOpaque256000}

  setup do
    code =
      <<0, 97, 115, 109, 1, 0, 0, 0, 1, 19, 4, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96, 1,
        127, 0, 96, 0, 0, 2, 37, 6, 1, 118, 1, 95, 0, 0, 1, 118, 1, 54, 0, 1, 1, 97, 1, 48, 0, 0,
        1, 108, 1, 48, 0, 0>>

    %{
      code: code
    }
  end

  test "new/2", %{code: code} do
    %TxInstallContractCodeArgs{code: ^code} = TxInstallContractCodeArgs.new(code)
  end

  test "new/2 invalid_install_contract_code_args" do
    {:error, :invalid_install_contract_code_args} = TxInstallContractCodeArgs.new(1234)
  end

  test "to_xdr/1", %{code: code} do
    %InstallContractCodeArgs{
      code: %VariableOpaque256000{
        opaque: ^code
      }
    } =
      code
      |> TxInstallContractCodeArgs.new()
      |> TxInstallContractCodeArgs.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct_install_contract_code_args} =
      TxInstallContractCodeArgs.to_xdr("invalid_struct")
  end
end
