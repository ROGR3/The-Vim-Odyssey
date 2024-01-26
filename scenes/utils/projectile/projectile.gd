extends Area2D

const ATTACK_RANGE = 90
const SPEED = 80

var direction = 1
var angular_speed = 20
var rotation_direction = randf_range(-1, 1)

var start_position: Vector2


func _process(delta):
	rotation_degrees += rotation_direction * angular_speed * delta
	rotation_degrees = fmod(rotation_degrees, 360)

	position.x += SPEED * delta * direction
	if (
		direction == -1 and position.x < start_position.x - ATTACK_RANGE
		or direction == 1 and position.x > start_position.x + ATTACK_RANGE
	):
		queue_free()


func init(letter, pos, dir):
	$Label.text = letter
	start_position = pos
	self.position = pos
	direction = dir
