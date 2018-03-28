defmodule IslandsEngine.RulesTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Rules

  test "transition through gameplay states" do
    rules = Rules.new()
    assert rules == %Rules{player1: :islands_not_set, player2: :islands_not_set, state: :initialized}
    # adding a player and make sure that we transition to :players_set:
    {:ok, rules} = Rules.check(rules, :add_player)

    assert rules == %Rules{
             player1: :islands_not_set,
             player2: :islands_not_set,
             state: :players_set
           }

    # Each player should be able to move an island and the state should still be :players_set:
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})

    assert rules == %Rules{
             player1: :islands_not_set,
             player2: :islands_not_set,
             state: :players_set
           }

    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})

    assert rules == %Rules{
             player1: :islands_not_set,
             player2: :islands_not_set,
             state: :players_set
           }

    # A player can position islands after the other has set theirs
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    assert rules == %Rules{player1: :islands_set, player2: :islands_not_set, state: :players_set}

    # They are set
    assert Rules.check(rules, {:position_islands, :player1}) == :error

    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules == %Rules{player1: :islands_set, player2: :islands_not_set, state: :players_set}

    # When both players set their islands, the state should transition to :player1_turn:
    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    assert rules == %Rules{player1: :islands_set, player2: :islands_set, state: :player1_turn}

    # alternate guessing coordinates
    # it's player1 turn
    assert Rules.check(rules, {:guess_coordinate, :player2}) == :error

    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
    assert rules == %Rules{player1: :islands_set, player2: :islands_set, state: :player2_turn}

    # now it's player2 turn
    assert Rules.check(rules, {:guess_coordinate, :player1}) == :error

    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player2})
    assert rules == %Rules{player1: :islands_set, player2: :islands_set, state: :player1_turn}
    # :no_win should not transition state
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules == %Rules{player1: :islands_set, player2: :islands_set, state: :player1_turn}

    # :win transitions to :game_over
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules == %Rules{player1: :islands_set, player2: :islands_set, state: :game_over}
  end
end
