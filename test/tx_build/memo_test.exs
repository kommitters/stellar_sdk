defmodule Stellar.TxBuild.MemoTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [memo_xdr: 2]
  alias Stellar.TxBuild.Memo

  describe "new/2" do
    test "default" do
      %Memo{type: :MEMO_NONE, value: nil} = Memo.new()
    end

    test "memo_none" do
      %Memo{type: :MEMO_NONE, value: nil} = Memo.new(:none)
    end

    test "memo_text" do
      %Memo{type: :MEMO_TEXT, value: "hello"} = Memo.new(text: "hello")
    end

    test "memo_id" do
      %Memo{type: :MEMO_ID, value: 123} = Memo.new(id: 123)
    end

    test "memo_hash" do
      %Memo{
        type: :MEMO_HASH,
        value: "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510"
      } = Memo.new(hash: "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510")
    end

    test "memo_return" do
      %Memo{
        type: :MEMO_RETURN,
        value: "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510"
      } = Memo.new(return: "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510")
    end

    test "invalid_memo" do
      {:error, :invalid_memo} = Memo.new(:test, 123)
    end
  end

  describe "to_xdr/1" do
    test "memo_none" do
      memo_none_xdr = memo_xdr(:MEMO_NONE, nil)
      ^memo_none_xdr = Memo.new(:none, nil) |> Memo.to_xdr()
    end

    test "memo_text" do
      memo_text_xdr = memo_xdr(:MEMO_TEXT, "hello")
      ^memo_text_xdr = Memo.new(text: "hello") |> Memo.to_xdr()
    end

    test "memo_id" do
      memo_id_xdr = memo_xdr(:MEMO_ID, 123)
      ^memo_id_xdr = Memo.new(id: 123) |> Memo.to_xdr()
    end

    test "memo_hash" do
      hash = "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510"
      memo_hash_xdr = memo_xdr(:MEMO_HASH, hash)

      ^memo_hash_xdr =
        [hash: hash]
        |> Memo.new()
        |> Memo.to_xdr()
    end

    test "memo_return" do
      hash = "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510"
      memo_return_xdr = memo_xdr(:MEMO_RETURN, hash)

      ^memo_return_xdr =
        [return: hash]
        |> Memo.new()
        |> Memo.to_xdr()
    end
  end
end
