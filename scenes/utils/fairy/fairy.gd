extends CharacterBody2D


var chase_player = false
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if chase_player == true:
		var player = $"../Player"
		var direction = (player.position - self.position).normalized()
		anim.play("Chase")
		if direction.x > 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
		self.velocity.x = direction.x * 150
	else:
		self.velocity.x = 0
		anim.play("Idle")
	move_and_slide()

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase_player = true


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase_player = false


func show_text(text: String) -> void:
	$SpeechBubble.set_text(text)
