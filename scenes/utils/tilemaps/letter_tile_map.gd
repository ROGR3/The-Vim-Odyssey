extends TileMap

var letter_size: int = 16

# --------------------
# Built-in Methods
# --------------------

# --------------------
# Public Methods
# --------------------

func find_end_of_word(player_position: Vector2) -> Vector2:
	var staying_block := __get_block_one_down(player_position)
	var current_cell: Vector2i = __transform_to_tileset_coords(staying_block)

	if not Vector2i(current_cell.x, current_cell.y) in self.get_used_cells(0):
		return player_position

	var word_end := __find_last_available_cell(current_cell)
	return __transform_from_tileset_coords(word_end)

func find_beginning_of_word(player_position: Vector2) -> Vector2:
	var staying_block: Vector2 = __get_block_one_down(player_position)
	var current_cell: Vector2i = __transform_to_tileset_coords(staying_block)

	if not Vector2i(current_cell.x, current_cell.y) in self.get_used_cells(0):
		return player_position

	var word_beginning: Vector2 = __find_first_available_cell(current_cell)
	return __transform_from_tileset_coords(word_beginning)

# --------------------
# Private methods
# --------------------

func __transform_to_tileset_coords(coords: Vector2) -> Vector2i:
	return Vector2i(coords.x / letter_size, coords.y / letter_size)

func __transform_from_tileset_coords(coords: Vector2i) -> Vector2:
	return Vector2(coords.x * letter_size, coords.y * letter_size)

func __get_block_one_down(coords: Vector2) -> Vector2:
	return Vector2(coords.x, coords.y + letter_size)

func __find_last_available_cell(current: Vector2i) -> Vector2:
	var all_cells: Array = self.get_used_cells(0)

	while Vector2i(current.x, current.y) in all_cells:
		current.x += 1
	return Vector2(current.x - .51, current.y - 1)

func __find_first_available_cell(current: Vector2i) -> Vector2:
	var all_cells: Array = self.get_used_cells(0)

	while Vector2i(current.x, current.y) in all_cells:
		current.x -= 1
	return Vector2(current.x + 1.51, current.y - 1)
