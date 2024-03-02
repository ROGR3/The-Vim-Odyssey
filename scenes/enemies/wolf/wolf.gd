extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@onready var player := $"../Player"

var gravity := 200
var movement_speed := 30

var player_detection_range := 150
var player_attack_range := 40
var player_death_range := 25

var is_following_player := false
var is_attacking_player := false

# --------------------
# Built-in Methods
# --------------------

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var direction: Vector2 = (player.global_position - global_position).normalized()
	if is_attacking_player:
		anim.flip_h = direction.x > 0
		anim.play("Attack")
	elif is_following_player:
		anim.flip_h = direction.x > 0
		self.velocity.x = movement_speed * direction.x
		anim.play("Run")
	else:
		self.velocity.x = 0
		anim.play("Idle")

	move_and_slide()

func _on_attack_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking_player = true

func _on_attack_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking_player = false

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_following_player = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_following_player = false

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
