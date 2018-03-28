defmodule IslandsEngine.BoardTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Board, Coordinate, Island}

  test "#all_islands_positioned?" do
    assert Board.all_islands_positioned?(%{}) == false
    {_, all_islands} = Enum.map_reduce(IslandsEngine.Island.types(), %{}, fn(type, acc) -> {type, Map.put(acc, type, "howdy")} end)
    assert Board.all_islands_positioned?(all_islands) == true
  end

  test "#new" do
    assert {:error, :invalid_island_type} = IslandsEngine.Island.new(:bad_type, %Coordinate{row: 1, col: 2})
    assert {:error, :invalid_coordinate} = IslandsEngine.Island.new(:square, %Coordinate{row: 1, col: -1})

    assert {:ok, %Island{} = island} = IslandsEngine.Island.new(:square, %Coordinate{row: 1, col: 1})

  end
end
