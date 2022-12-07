defmodule NewsApiTest do
  use ExUnit.Case
  doctest NewsApi

  test "greets the world" do
    assert NewsApi.hello() == :world
  end
end
