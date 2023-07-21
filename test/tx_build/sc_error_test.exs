defmodule Stellar.TxBuild.SCErrorTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCError
  alias StellarBase.XDR.SCError, as: SCErrorXDR

  setup do
    error_discriminants = [
      %{type: :contract, code: :arith_domain},
      %{type: :wasm_vm, code: :index_bounds},
      %{type: :context, code: :invalid_input},
      %{type: :storage, code: :missing_value},
      %{type: :object, code: :existing_value},
      %{type: :crypto, code: :exceeded_limit},
      %{type: :events, code: :invalid_action},
      %{type: :budget, code: :internal_error},
      %{type: :code, code: :unexpected_type},
      %{type: :auth, code: :unexpected_size}
    ]

    xdr_discriminants = [
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_CONTRACT},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_ARITH_DOMAIN}
        },
        type: :contract,
        code: :arith_domain
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_WASM_VM},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_INDEX_BOUNDS}
        },
        type: :wasm_vm,
        code: :index_bounds
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_CONTEXT},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_INVALID_INPUT}
        },
        type: :context,
        code: :invalid_input
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_STORAGE},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_MISSING_VALUE}
        },
        type: :storage,
        code: :missing_value
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_OBJECT},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_EXISTING_VALUE}
        },
        type: :object,
        code: :existing_value
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_CRYPTO},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_EXCEEDED_LIMIT}
        },
        type: :crypto,
        code: :exceeded_limit
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_EVENTS},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_INVALID_ACTION}
        },
        type: :events,
        code: :invalid_action
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_BUDGET},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_INTERNAL_ERROR}
        },
        type: :budget,
        code: :internal_error
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_VALUE},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_UNEXPECTED_TYPE}
        },
        type: :code,
        code: :unexpected_type
      },
      %{
        xdr: %SCErrorXDR{
          type: %StellarBase.XDR.SCErrorType{identifier: :SCE_AUTH},
          code: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_UNEXPECTED_SIZE}
        },
        type: :auth,
        code: :unexpected_size
      }
    ]

    %{error_discriminants: error_discriminants, xdr_discriminants: xdr_discriminants}
  end

  test "new/2", %{error_discriminants: error_discriminants} do
    for %{type: type, code: code} <- error_discriminants do
      %SCError{
        type: ^type,
        code: ^code
      } = SCError.new([{type, code}])
    end
  end

  test "new/2 invalid args" do
    {:error, :invalid_sc_error} = SCError.new(invalid_type: :invalid)
  end

  test "to_xdr/1", %{xdr_discriminants: xdr_discriminants} do
    for %{xdr: xdr, type: type, code: code} <- xdr_discriminants do
      ^xdr = SCError.new([{type, code}]) |> SCError.to_xdr()
    end
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SCError.to_xdr(:invalid)
  end
end
