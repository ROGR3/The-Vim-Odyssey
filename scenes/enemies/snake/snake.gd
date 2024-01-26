extends Area2D

@onready var anim = $AnimatedSprite2D

var is_player_detected = false

func _process(delta):
	if is_player_detected:
		anim.play("Attack")
	else:
		anim.play("Idle")


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		is_player_detected = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		is_player_detected = false

