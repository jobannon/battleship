require './lib/cell'
require 'pry'

class Board

  attr_reader :cells
  def initialize
    @cells =
    {
      "A1" => Cell.new("A1"),
      "A2" => Cell.new("A2"),
      "A3" => Cell.new("A3"),
      "A4" => Cell.new("A4"),
      "B1" => Cell.new("B1"),
      "B2" => Cell.new("B2"),
      "B3" => Cell.new("B3"),
      "B4" => Cell.new("B4"),
      "C1" => Cell.new("C1"),
      "C2" => Cell.new("C2"),
      "C3" => Cell.new("C3"),
      "C4" => Cell.new("C4"),
      "D1" => Cell.new("D1"),
      "D2" => Cell.new("D2"),
      "D3" => Cell.new("D3"),
      "D4" => Cell.new("D4")
  }
  end

  def valid_coordinate?(cell)
    @cells.keys.include?(cell)
  end

  def split_coordinates(cells_array)
    cells_array.map do |cell|
      cell.split(//, 2)
    end
  end

  def filter_alpha_array(split_array)
    split_array.map do |inner_array|
      inner_array.first.ord
    end
  end

  def filter_numeric_array(split_array)
    split_array.map do |inner_array|
      inner_array.last.to_i
    end
  end

  def valid_length?(ship, cells_placed_array)
    ship.length == cells_placed_array.length
  end

  def consecutive_numbers?(coordinates_split)
    number_array = filter_numeric_array(coordinates_split)
    number_array.each_cons(2).all? { |a,b| b == a + 1 }
  end

  def consecutive_alphas?(coordinates_split)
    alpha_array = filter_alpha_array(coordinates_split)
    alpha_array.each_cons(2).all? { |a,b| b == a + 1 }
  end

  def same_numbers?(coordinates_split)
    number_array = filter_numeric_array(coordinates_split)
    number_array.each_cons(2).all? { |a,b| b == a }
  end

  def same_alphas?(coordinates_split)
    alpha_array = filter_alpha_array(coordinates_split)
    alpha_array.each_cons(2).all? { |a,b| b == a }
  end

  def valid_placement?(ship, cells_placed_array)
    coordinates_split = split_coordinates(cells_placed_array)

    if same_alphas?(coordinates_split) && consecutive_numbers?(coordinates_split) && valid_length?(ship, cells_placed_array)
      true
    elsif consecutive_alphas?(coordinates_split) && same_numbers?(coordinates_split) && valid_length?(ship, cells_placed_array)
      true
    else
      false
    end
  end

  def ship_placed?(coordinates)
    occupado = coordinates.map do |coord|
      @cells[coord].empty?
    end
    occupado.include?(false)
  end

  def place(ship, coordinates_array)
    if valid_placement?(ship, coordinates_array)
      coordinates_array.each do |individual_coordinate|
        @cells[individual_coordinate].place_ship(ship)
      end
    else
      p "cannot place ship"
    end
  end

  def render_board(show = false)
    if show == false
      "  1 2 3 4 \n" +
      "A #{@cells.values[0].render} #{@cells.values[1].render} #{@cells.values[2].render} #{@cells.values[3].render} \n" +
      "B #{@cells.values[4].render} #{@cells.values[5].render} #{@cells.values[6].render} #{@cells.values[7].render} \n" +
      "C #{@cells.values[8].render} #{@cells.values[9].render} #{@cells.values[10].render} #{@cells.values[11].render} \n" +
      "D #{@cells.values[12].render} #{@cells.values[13].render} #{@cells.values[14].render} #{@cells.values[15].render} \n"
    elsif show == true
      "  1 2 3 4 \n" +
      "A #{@cells.values[0].render(true)} #{@cells.values[1].render(true)} #{@cells.values[2].render(true)} #{@cells.values[3].render(true)} \n" +
      "B #{@cells.values[4].render(true)} #{@cells.values[5].render(true)} #{@cells.values[6].render(true)} #{@cells.values[7].render(true)} \n" +
      "C #{@cells.values[8].render(true)} #{@cells.values[9].render(true)} #{@cells.values[10].render(true)} #{@cells.values[11].render(true)} \n" +
      "D #{@cells.values[12].render(true)} #{@cells.values[13].render(true)} #{@cells.values[14].render(true)} #{@cells.values[15].render(true)} \n"
    end
  end
end
