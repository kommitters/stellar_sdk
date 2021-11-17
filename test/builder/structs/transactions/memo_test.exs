defmodule Stellar.Builder.Structs.MemoTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [memo_xdr: 2]
  alias Stellar.Builder.Structs.Memo

  describe "new/2" do
    test "default" do
      %Memo{type: :MEMO_NONE, value: nil} = Memo.new()
    end

    test "memo_none" do
      %Memo{type: :MEMO_NONE, value: nil} = Memo.new(:none, nil)
    end

    test "memo_text" do
      %Memo{type: :MEMO_TEXT, value: "hello"} = Memo.new(:text, "hello")
    end

    test "memo_id" do
      %Memo{type: :MEMO_ID, value: 123} = Memo.new(:id, 123)
    end

    test "memo_hash" do
      %Memo{type: :MEMO_HASH, value: <<0, 0, 0, 0>>} = Memo.new(:hash, <<0, 0, 0, 0>>)
    end

    test "memo_return" do
      %Memo{type: :MEMO_RETURN, value: <<0, 0, 0, 0>>} = Memo.new(:return, <<0, 0, 0, 0>>)
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
      ^memo_text_xdr = Memo.new(:text, "hello") |> Memo.to_xdr()
    end

    test "memo_id" do
      memo_id_xdr = memo_xdr(:MEMO_ID, 123)
      ^memo_id_xdr = Memo.new(:id, 123) |> Memo.to_xdr()
    end

    test "memo_hash" do
      hash = "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"
      memo_hash_xdr = memo_xdr(:MEMO_HASH, hash)

      ^memo_hash_xdr = Memo.new(:hash, hash) |> Memo.to_xdr()
    end

    test "memo_return" do
      hash = "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"
      memo_return_xdr = memo_xdr(:MEMO_RETURN, "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN")

      ^memo_return_xdr = Memo.new(:return, hash) |> Memo.to_xdr()
    end
  end
end
