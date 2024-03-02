extends Node2D

@onready var text_node := $Label
@onready var text_bg := $ColorRect

const duration = .5
const margin_offset = 8
var expected_width: float = 0

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	self.visible = false
	text_node.visible = false

# --------------------
# Public Methods
# --------------------

func set_text(text_value: String) -> void:
	self.visible = true
	text_node.text = text_value
	var tween_node := get_tree().create_tween()
	expected_width = text_node.get_content_width()
	text_node.size.y = text_node.get_content_height()
	text_bg.size.y = text_node.get_content_height() + margin_offset
	tween_node.tween_method(__grow_width, 0, expected_width + margin_offset, duration)

func hide_text() -> void:
	self.visible = false

# --------------------
# Private methods
# --------------------

func __grow_width(value: int) -> void:
	text_bg.size.x = value
	if value < expected_width:
		text_node.size.x = value
	else:
		text_node.visible = true
