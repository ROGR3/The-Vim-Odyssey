extends Area2D

@export var spawnpoint := false

@onready var anim := $AnimatedSprite2D

var active_checkpoint := false

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	if spawnpoint:
		self.visible = false
		__activate_checkpoint()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player"&&!active_checkpoint:
		__activate_checkpoint()

func __activate_checkpoint() -> void:
	if Global.current_checkpoint:
		Global.current_checkpoint.__deactivate()
	Global.current_checkpoint = self
	active_checkpoint = true
	anim.play("Saved")

func __deactivate() -> void:
	active_checkpoint = false
	anim.stop()
	
# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
