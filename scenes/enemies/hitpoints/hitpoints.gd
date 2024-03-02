extends Node2D

@onready var label := $RichTextLabel

var showed_text := ""
var already_written_text: String = ""

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	label.bbcode_enabled = true

# --------------------
# Public Methods
# --------------------

func set_starting_text(text: String) -> void:
	showed_text = text
	__set_text(showed_text)

func hit_by_letter(letter: String) -> void:
	already_written_text += letter
	if !__is_input_correct():
		already_written_text = ""
	__update_label()

func is_complete() -> bool:
	return already_written_text == showed_text

# --------------------
# Private methods
# --------------------

func __is_input_correct() -> bool:
	return showed_text.begins_with(already_written_text)

func __update_label() -> void:
	var bbcode_text: String = "[color=#222]" + already_written_text + "[/color] "
	bbcode_text += showed_text.substr(already_written_text.length())
	__set_text(bbcode_text)

func __set_text(text: String) -> void:
	label.clear()
	label.append_text(text)
