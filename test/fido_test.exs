defmodule FidoTest do
  use ExUnit.Case
  doctest Fido

  test "greets the world" do
    assert Fido.hello() == :world
  end
end
