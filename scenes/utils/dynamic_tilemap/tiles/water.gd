extends Area2D


func _ready() -> void:
	$AnimatedSprite2D.play("Idle")


func _on_body_entered(body: Node2D) -> void:
	print(" SOMETHING IS IN WATER")
	if body.name == "Player" and body.is_killable:
		body.die()
