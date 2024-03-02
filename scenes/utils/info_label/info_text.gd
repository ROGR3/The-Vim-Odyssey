extends Area2D

@export var is_nullifier := false
@export_multiline var text := "some text to show"
@export var is_starting_point := false
@export var is_castable_ability := false
@export var ability: String = ""

@onready var fairy_node := $"../../Fairy"

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	if is_starting_point:
		await get_tree().create_timer(2).timeout
		fairy_node.show_text(text)
		if is_castable_ability:
			fairy_node.cast_ability()
			Global.unlock_ability(ability)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !is_starting_point:
		if is_nullifier:
			fairy_node.hide_text()
			queue_free()
			return
		fairy_node.show_text(text)
		if is_castable_ability:
			fairy_node.cast_ability()
			Global.unlock_ability(ability)
		queue_free()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
