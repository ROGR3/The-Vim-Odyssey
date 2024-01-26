extends Area2D

var movement_range = 40
var speed = 50
var direction = Vector2.RIGHT
var initial_position: Vector2


func _ready():
	initial_position = position


func _process(delta: float) -> void:
	var movement = direction.normalized() * speed * delta
	position += movement
	if position.distance_to(initial_position) >= movement_range:
		direction = -direction
