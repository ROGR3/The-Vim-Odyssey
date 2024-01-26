extends Area2D

@onready var fairy_node = $"../../Fairy"
@export var text = "some text to show"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		fairy_node.show_text(text)
		queue_free()
