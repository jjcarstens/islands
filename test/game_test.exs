defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Game

  test "adding players" do
    {:ok, game} = Game.start_link("JonJon")
    :ok = Game.add_player(game, "EStephanie!")

    state_data = :sys.get_state(game)

    assert state_data.player1.name == "JonJon"
    assert state_data.player2.name == "EStephanie!"

    assert state_data.rules == %IslandsEngine.Rules{
      player1: :islands_not_set,
      player2: :islands_not_set,
      state: :players_set
    }

    assert {:error, "Only 2 players allowed"} == Game.add_player(game, "wat?!")
  end

  test "position_islands" do
    {:ok, game} = Game.start_link("JonJon")
    :ok = Game.add_player(game, "EStephanie!")

    :ok = Game.position_island(game, :player1, :square, 7, 7)

    state_data = :sys.get_state(game)

    coordinates = [
      %IslandsEngine.Coordinate{col: 7, row: 7},
      %IslandsEngine.Coordinate{col: 7, row: 8},
      %IslandsEngine.Coordinate{col: 8, row: 7},
      %IslandsEngine.Coordinate{col: 8, row: 8}
    ]
    coordinates_mapset = Enum.reduce(coordinates, MapSet.new, &MapSet.put(&2, &1))

    assert state_data.player1.board == %{
      square: %IslandsEngine.Island{
        coordinates: coordinates_mapset,
        hit_coordinates: %MapSet{}
      }
    }

    assert {:error, :invalid_coordinate} == Game.position_island(game, :player1, :l_shape, 10, 10)
    assert {:error, :invalid_island_type} == Game.position_island(game, :player1, :howdy, 10, 10)
  end
end
