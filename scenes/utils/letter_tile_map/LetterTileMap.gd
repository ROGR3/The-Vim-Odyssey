extends TileMap

var letter_size: int = 16

func find_end_of_word(player_position: Vector2) -> Vector2:
	var staying_block = get_block_one_down(player_position)
	var current_cell = transform_to_tileset_coords(staying_block)

	if not Vector2i(current_cell.x, current_cell.y) in get_used_cells(0):
		return player_position

	var word_end = find_last_available_cell(current_cell)
	return transform_from_tileset_coords(word_end)

func find_beginning_of_word(player_position: Vector2) -> Vector2:
	var staying_block: Vector2 = get_block_one_down(player_position)
	var current_cell: Vector2 = transform_to_tileset_coords(staying_block)

	if not Vector2i(current_cell.x, current_cell.y) in get_used_cells(0):
		return player_position

	var word_beginning: Vector2 = find_first_available_cell(current_cell)
	return transform_from_tileset_coords(word_beginning)


func transform_to_tileset_coords(coords: Vector2) -> Vector2:
	return Vector2(round(coords.x / letter_size), round(coords.y / letter_size))

func transform_from_tileset_coords(coords: Vector2) -> Vector2:
	return Vector2(coords.x * letter_size, coords.y * letter_size)

func get_block_one_down(coords: Vector2) -> Vector2:
	return Vector2(coords.x, coords.y + letter_size)

func find_last_available_cell(current: Vector2) -> Vector2:
	var all_cells: Array = get_used_cells(0)

	while Vector2i(current.x, current.y) in all_cells:
		current.x += 1
	return Vector2(current.x - .51, current.y - 1)

func find_first_available_cell(current: Vector2) -> Vector2:
	var all_cells: Array = get_used_cells(0)

	while Vector2i(current.x, current.y) in all_cells:
		current.x -= 1
	return Vector2(current.x + 1.51, current.y - 1)
