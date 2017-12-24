defmodule Day22.Part1 do
  alias Day22.Grid

  def new_direction(status, direction) do
    case status do
      :clean -> Grid.turn_left(direction)
      :infected -> Grid.turn_right(direction)
    end
  end

  def update_at(grid, position) do
    case Grid.value_at(grid, position) do
      :clean -> {Map.put(grid, position, :infected), :infected}
      :infected -> {Map.put(grid, position, :clean), :cleaned}
    end
  end
end
