extends CharacterBody2D

var chase_player := false
var speed := 100
@onready var anim := $AnimatedSprite2D
@onready var player := $"../Player"
var spell_cast_projectile := preload ("res://scenes/utils/fairy/spell_cast.tscn")
var projectile_instance: Node = null

var is_spawning := true

@onready var target_position := self.position
@onready var starting_position := Vector2(target_position.x - 100, target_position.y - 30)

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	self.position = starting_position

func _physics_process(_delta: float) -> void:
	if is_spawning:
		anim.play("Spawn")
		var direction: Vector2 = (target_position - self.position).normalized()
		self.velocity = direction * speed
		move_and_slide()
		await anim.animation_finished
		is_spawning = false
		self.velocity = Vector2.ZERO
		return

	if projectile_instance != null and projectile_instance.following_body == null:
		anim.play("Cast")
		await anim.animation_finished
		projectile_instance.visible = true
		projectile_instance.start_following_body(player)

	if chase_player == true:
		var direction: Vector2 = (player.position - self.position).normalized()
		anim.play("Chase")
		anim.flip_h = direction.x < 0
		self.velocity.x = direction.x * speed
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

# --------------------
# Public Methods
# --------------------

func show_text(text: String) -> void:
	$SpeechBubble.set_text(text)

func hide_text() -> void:
	$SpeechBubble.hide_text()

func cast_ability() -> void:
	projectile_instance = spell_cast_projectile.instantiate()
	projectile_instance.position = self.position
	owner.add_child(projectile_instance)

# --------------------
# Private methods
# --------------------
