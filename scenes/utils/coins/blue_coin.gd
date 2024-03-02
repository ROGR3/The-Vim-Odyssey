extends Area2D

var is_already_collected := false

# --------------------
# Built-in Methods
# --------------------

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player" and is_already_collected:
		body.coin_collected(1)
		$CPUParticles2D.emitting = true
		$Sprite2D.visible = false
		is_already_collected = true
		await get_tree().create_timer(2).timeout
		queue_free()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
