extends Area2D

# --------------------
# Built-in Methods
# --------------------

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.heart_collected(1)
		queue_free()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
