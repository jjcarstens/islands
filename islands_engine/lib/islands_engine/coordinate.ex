defmodule IslandsEngine.Coordinate do
  @board_range 1..10
  defguard in_range(row, col) when row in(@board_range) and col in(@board_range)

  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]


  def new(row, col) when in_range(row, col), do: {:ok, %Coordinate{row: row, col: col}}
  def new(_row, _col), do: {:error, :invalid_coordinate}
  def new!(row, col) when in_range(row, col), do: %Coordinate{row: row, col: col}
end
