extends Area2D

@onready var anim = $AnimatedSprite2D


func _on_body_entered(body):
	if body.name == "Player":
		Global.change_scene("res://scenes/map.tscn")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	anim.play("Spawn")
	await anim.animation_finished
	anim.play("Idle")
