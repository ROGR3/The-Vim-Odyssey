extends TileMap

var mapping := {
	"Water": preload ("res://scenes/utils/tilemaps/tiles/water.tscn"),
}

var cell_cize := 16

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	for cellpos in get_used_cells(0):
		var source := tile_set.get_source(get_cell_source_id(0, cellpos, false))
		var data: TileData = source.get_tile_data(get_cell_atlas_coords(0, cellpos, false), 0)
		var type: String = data.get_custom_data("Cell Type")
		if type in mapping:
			__replace_tile_with_object(cellpos, mapping.get(type))

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------

func __replace_tile_with_object(pos: Vector2, obj: PackedScene) -> void:
	var new_obj := obj.instantiate()
	new_obj.position.x = pos.x * cell_cize + 8
	new_obj.position.y = pos.y * cell_cize + 8
	add_child(new_obj)
	set_cell(0, pos, -1)
