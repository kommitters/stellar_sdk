defmodule Stellar.Horizon.Operation.BumpSequenceTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.BumpSequence

  setup do
    %{attrs: %{bump_to: "120192344968520085"}}
  end

  test "new/2", %{attrs: attrs} do
    %BumpSequence{bump_to: 120_192_344_968_520_085} = BumpSequence.new(attrs)
  end

  test "new/2 empty_attrs" do
    %BumpSequence{bump_to: nil} = BumpSequence.new(%{})
  end
end
