extends Area2D

@onready var anim := $AnimatedSprite2D

# --------------------
# Built-in Methods
# --------------------

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		Global.change_scene("res://scenes/map.tscn")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	anim.play("Spawn")
	await anim.animation_finished
	anim.play("Idle")

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
