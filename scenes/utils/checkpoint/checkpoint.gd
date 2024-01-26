extends Area2D

@export var spawnpoint = false

var active_checkpoint = false

@onready var anim = $AnimatedSprite2D


func _ready() -> void:
	if spawnpoint:
		self.visible = false
		activate_checkpoint()


func activate_checkpoint() -> void:
	if Global.current_checkpoint:
		Global.current_checkpoint.deactivate()
	Global.current_checkpoint = self
	active_checkpoint = true
	anim.play("Saved")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" && !active_checkpoint:
		activate_checkpoint()


func deactivate() -> void:
	active_checkpoint = false
	anim.stop()
