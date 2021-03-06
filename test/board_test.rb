require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require 'pry'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_initializes
    assert_equal Hash, @board.cells.class
  end

  def test_hash_contents
    assert_equal 16, @board.cells.length
    assert_equal "A1", @board.cells.keys[0].to_s
    assert_equal "D2", @board.cells.keys[13].to_s
  end

  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_valid_placement_for_length
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "A3", "A4"])
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
  end

  def test_valid_placement_is_consecutive
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])
    assert_equal false, @board.valid_placement?(@submarine, [])
  end

  def test_valid_placement_diagonals
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
  end

  def test_valid_placement
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
  end

  def test_place_ship_on_board
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    cell_1 = board.cells["A1"]
    cell_2 = board.cells["A2"]
    cell_3 = board.cells["A3"]
    assert_equal cruiser, cell_1.ship
    assert_equal cruiser, cell_2.ship
    assert_equal cruiser, cell_3.ship
    assert_equal true, cell_3.ship == cell_2.ship
  end

  def test_board_render
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    cell_1 = board.cells["A1"]
    cell_2 = board.cells["A2"]
    cell_3 = board.cells["A3"]
    cell_4 = board.cells["A4"]

    assert_equal "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n", board.render_board
    assert_equal "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n", board.render_board(true)
    cell_1.fire_upon
    assert_equal "  1 2 3 4 \nA H S S . \nB . . . . \nC . . . . \nD . . . . \n", board.render_board(true)
    cell_4.fire_upon
    assert_equal "  1 2 3 4 \nA H S S M \nB . . . . \nC . . . . \nD . . . . \n", board.render_board(true)
    cell_2.fire_upon
    cell_3.fire_upon
    assert_equal "  1 2 3 4 \nA X X X M \nB . . . . \nC . . . . \nD . . . . \n", board.render_board(true)
  end

  def test_split_coordinates
    assert_equal [["A", "1"], ["A", "2"], ["A", "3"]], @board.split_coordinates(["A1", "A2", "A3"])
  end

  def test_filter_arrays
    assert_equal [65, 65, 65], @board.filter_alpha_array(@board.split_coordinates(["A1", "A2", "A3"]))
    assert_equal [1, 2, 3], @board.filter_numeric_array(@board.split_coordinates(["A1", "A2", "A3"]))
  end

  def test_no_ships_placed
    assert_equal false, @board.ship_placed?(["A1", "A2", "A3"])
    @board.place(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.ship_placed?(["A1", "A2", "A3"])
    assert_equal true, @board.ship_placed?(["A1", "B1", "C1"])
  end

  def test_valid_length
    assert_equal true, @board.valid_length?(@cruiser, ["A1", "A2", "A3"])
    assert_equal false, @board.valid_length?(@cruiser, ["A1", "A2"])
  end

  def test_consecutive_numbers_helper
    assert_equal true, @board.consecutive_numbers?([["A", "1"], ["A", "2"], ["A", "3"]])
    assert_equal false, @board.consecutive_numbers?([["A", "1"], ["A", "2"], ["A", "4"]])
  end

  def test_consecutive_alphas
    assert_equal false, @board.consecutive_alphas?([["A", "1"], ["A", "2"], ["A", "3"]])
    assert_equal true, @board.consecutive_alphas?([["A", "1"], ["B", "1"], ["C", "1"]])
  end

  def test_same_numbers
    assert_equal true, @board.same_numbers?([["A", "1"], ["B", "1"], ["C", "1"]])
    assert_equal false, @board.same_numbers?([["A", "1"], ["B", "1"], ["C", "2"]])
  end

  def test_same_alphas
    assert_equal true, @board.same_alphas?([["D", "1"], ["D", "2"], ["D", "3"]])
    assert_equal false, @board.same_alphas?([["C", "1"], ["D", "2"], ["D", "3"]])
  end
end
