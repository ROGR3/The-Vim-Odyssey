extends Area2D


@onready var anim = $AnimatedSprite2D

func _ready():
	loop_anim()
	
func _on_body_entered(body):
	if body.name == "Player":
		body.coin_collected(10)
		queue_free()


func loop_anim():
	anim.play("default")
	await get_tree().create_timer(2).timeout
	loop_anim()
