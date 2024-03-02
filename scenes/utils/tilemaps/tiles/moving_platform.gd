extends AnimatableBody2D

@export var movement_range := 40
@export var speed := 100
@export var direction := Vector2.RIGHT

var current_distance := 0.0


func _physics_process(delta: float) -> void:
	var movement = speed * delta * direction
	self.position += movement
	current_distance += movement.length()
	if current_distance >= movement_range:
		direction = -direction
		current_distance = 0
