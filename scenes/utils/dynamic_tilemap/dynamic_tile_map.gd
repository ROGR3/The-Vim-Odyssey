extends TileMap

var mapping = {
	"water": preload("res://scenes/utils/dynamic_tilemap/tiles/water.tscn"),
	"moving_platform": preload("res://scenes/utils/dynamic_tilemap/tiles/moving_platform.tscn"),
}

var cell_cize = 16

func _ready():
	for cellpos in get_used_cells(0):
		var source = tile_set.get_source(get_cell_source_id(0, cellpos, false))
		var data: TileData = source.get_tile_data(get_cell_atlas_coords(0, cellpos, false), 0)
		var type = data.get_custom_data("Cell Type")
		if type in mapping:
			print("REplaceing")
			replace_tile_with_object(cellpos, mapping.get(type))



func replace_tile_with_object(pos: Vector2, obj) -> void:
	var new_obj = obj.instantiate()
	new_obj.position.x = pos.x * cell_cize + 8
	new_obj.position.y = pos.y * cell_cize + 8
	add_child(new_obj)
	set_cell(0,pos,-1)
