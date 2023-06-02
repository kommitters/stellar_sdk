defmodule Stellar.TxBuild.HostFunctionArgsArgsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Asset, HostFunctionArgs, SCVal}

  import Stellar.Test.XDRFixtures,
    only: [
      host_function_xdr: 4,
      host_function_upload_xdr: 2,
      host_function_create_with_wasm_xdr: 3,
      host_function_create_with_asset: 1
    ]

  describe "HostFunctionArgs invoke" do
    setup do
      type = :invoke
      upload_type = :upload
      create_type = :create
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]

      code =
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 19, 4, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          1, 127, 0, 96, 0, 0, 2, 37, 6, 1, 118, 1, 95, 0, 0, 1, 118, 1, 54, 0, 1, 1, 97, 1, 48,
          0, 0, 1, 108, 1, 48, 0, 0>>

      wasm_id =
        <<86, 32, 6, 9, 172, 4, 212, 185, 249, 87, 184, 164, 58, 34, 167, 183, 226, 117, 205, 116,
          11, 130, 119, 172, 224, 51, 12, 148, 90, 251, 17, 12>>

      salt = :crypto.strong_rand_bytes(32)

      asset = Asset.new(:native)

      %{
        type: type,
        upload_type: upload_type,
        create_type: create_type,
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        xdr: host_function_xdr(type, contract_id, function_name, args),
        upload_xdr: host_function_upload_xdr(upload_type, code),
        create_wasm_xdr: host_function_create_with_wasm_xdr(create_type, wasm_id, salt),
        create_asset_xdr: host_function_create_with_asset(create_type),
        code: code,
        wasm_id: wasm_id,
        salt: salt,
        asset: asset
      }
    end

    test "new/2", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name,
      args: args
    } do
      %HostFunctionArgs{
        type: ^type,
        contract_id: ^contract_id,
        function_name: ^function_name,
        args: ^args
      } =
        HostFunctionArgs.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )
    end

    test "new/2 with_invalid_type", %{
      contract_id: contract_id,
      function_name: function_name,
      args: args
    } do
      {:error, :invalid_operation_attributes} =
        HostFunctionArgs.new(
          type: :invalid,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )
    end

    test "new/2 with_invalid_contract_id", %{
      type: type,
      function_name: function_name,
      args: args
    } do
      {:error, :invalid_contract_id} =
        HostFunctionArgs.new(
          type: type,
          contract_id: "hello-not-hex-encoded-string",
          function_name: function_name,
          args: args
        )
    end

    test "new/2 with_invalid_function_name", %{
      type: type,
      contract_id: contract_id,
      args: args
    } do
      {:error, :invalid_function_name} =
        HostFunctionArgs.new(
          type: type,
          contract_id: contract_id,
          function_name: 123,
          args: args
        )
    end

    test "new/2 with_invalid_args", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name
    } do
      {:error, :invalid_args} =
        HostFunctionArgs.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: [1, 2, 3]
        )
    end

    test "new/2 when type is :upload", %{upload_type: type, code: code} do
      %HostFunctionArgs{type: ^type, code: ^code} =
        HostFunctionArgs.new(
          type: type,
          code: code
        )
    end

    test "new/2 when type is :upload with invalid code", %{upload_type: type} do
      {:error, :invalid_operation_attributes} =
        HostFunctionArgs.new(
          type: type,
          code: 1234
        )
    end

    test "new/2 when type is :create with wasm_id without salt", %{
      create_type: type,
      wasm_id: wasm_id
    } do
      %HostFunctionArgs{type: ^type, wasm_id: ^wasm_id} =
        HostFunctionArgs.new(
          type: type,
          wasm_id: wasm_id
        )
    end

    test "new/2 when type is :create with invalid wasm_id", %{create_type: type} do
      {:error, :invalid_wasm_id} =
        HostFunctionArgs.new(
          type: type,
          wasm_id: 123
        )
    end

    test "new/2 when type is :create with wasm_id and salt", %{
      create_type: type,
      wasm_id: wasm_id,
      salt: salt
    } do
      %HostFunctionArgs{type: ^type, wasm_id: ^wasm_id, salt: ^salt} =
        HostFunctionArgs.new(
          type: type,
          wasm_id: wasm_id,
          salt: salt
        )
    end

    test "new/2 when type is :create with invalid salt", %{create_type: type, wasm_id: wasm_id} do
      {:error, :invalid_salt} =
        HostFunctionArgs.new(
          type: type,
          wasm_id: wasm_id,
          salt: 123
        )
    end

    test "new/2 when type is :create with asset", %{create_type: type, asset: asset} do
      %HostFunctionArgs{type: ^type, asset: ^asset} =
        HostFunctionArgs.new(
          type: type,
          asset: asset
        )
    end

    test "new/2 when type is :create with invalid asset", %{create_type: type} do
      {:error, :invalid_asset} =
        HostFunctionArgs.new(
          type: type,
          asset: 123
        )
    end

    test "to_xdr/1", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name,
      args: args,
      xdr: xdr
    } do
      ^xdr =
        [type: type, contract_id: contract_id, function_name: function_name, args: args]
        |> HostFunctionArgs.new()
        |> HostFunctionArgs.to_xdr()
    end

    test "to_xdr/1 upload", %{
      upload_type: upload_type,
      code: code,
      upload_xdr: upload_xdr
    } do
      ^upload_xdr =
        [type: upload_type, code: code]
        |> HostFunctionArgs.new()
        |> HostFunctionArgs.to_xdr()
    end

    test "to_xdr/1 when type is :create with wasm_id", %{
      create_type: type,
      wasm_id: wasm_id,
      salt: salt,
      create_wasm_xdr: xdr
    } do
      ^xdr =
        [type: type, wasm_id: wasm_id, salt: salt]
        |> HostFunctionArgs.new()
        |> HostFunctionArgs.to_xdr()
    end

    test "to_xdr/1 when type is :create with asset", %{
      create_type: type,
      asset: asset,
      create_asset_xdr: xdr
    } do
      ^xdr =
        [type: type, asset: asset]
        |> HostFunctionArgs.new()
        |> HostFunctionArgs.to_xdr()
    end
  end
end
