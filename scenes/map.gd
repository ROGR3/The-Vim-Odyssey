extends Node2D

@onready var player_sprite := $MapPlayer
@onready var level_buttons := $SelectButtons.get_children()

var current_level: int = 0

# --------------------
# Built-in methods
# --------------------
func _ready() -> void:
	player_sprite.position = level_buttons[Global.current_level].position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var path_string: String = Global.get_current_level_folder() + "main.tscn"
		Global.change_scene(path_string)
		return
	if event.is_action_pressed("vim_right"):
		move_to_next_level()
	elif event.is_action_pressed("vim_left"):
		move_to_prev_level()

# --------------------
# Public methods
# --------------------

func move_to_next_level() -> void:
	if len(level_buttons) - 1 <= Global.current_level:
		return
	Global.current_level += 1
	player_sprite.position = level_buttons[Global.current_level].position

func move_to_prev_level() -> void:
	if Global.current_level <= 0:
		return
	Global.current_level -= 1
	player_sprite.position = level_buttons[Global.current_level].position

# --------------------
# Private methods
# --------------------