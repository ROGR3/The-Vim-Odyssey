extends Node2D

@onready var text_node = $Label
@onready var text_bg = $ColorRect

const duration = .5
const margin_offset = 8

func _ready() -> void:
	visible = false

func set_text(text: String) -> void:
	visible = true
	text_node.text = text
	var tween_node = get_tree().create_tween()
	text_node.size.y = text_node.get_content_height()
	text_bg.size.y = text_node.get_content_height()
	tween_node.tween_method(_grow_width, 0, text_node.get_content_width(), duration)
	await get_tree().create_timer(10).timeout
	visible = false

func _grow_width(value: int) -> void:
	text_node.size.x = value
	text_bg.size.x = value

