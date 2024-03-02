extends Area2D

@onready var anim := $AnimatedSprite2D

# --------------------
# Built-in Methods
# --------------------

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		body.coin_collected(99)
		queue_free()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
