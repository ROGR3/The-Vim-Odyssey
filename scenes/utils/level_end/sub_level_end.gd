extends Area2D

@export var is_level_start := false

@onready var anim = $AnimatedSprite2D


func _ready() -> void:
	if is_level_start:
		anim.play("Dissapear")
		await anim.animation_finished
		queue_free()


func _on_body_entered(body):
	print("ENDETER")
	if body.name == "Player":
		var sub_level_scene = Global.get_current_level_folder() + "sublevel.tscn"
		Global.change_scene(sub_level_scene)



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not is_level_start:
		anim.play("Spawn")
		await anim.animation_finished
		anim.play("Idle")
