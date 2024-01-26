extends CharacterBody2D

enum CharacterState {
	IDLE,
	RUN,
	JUMP,
	CROUCH,
	CAST,
	FALL,
}
@export var movement_speed = 500.0
@export var jump_height := 100
@export var jump_time_to_peak := .4
@export var jump_time_to_descent := .3

@onready var jump_velocity := -((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity := -((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity := -((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@onready var anim = $AnimatedSprite2D
@onready var HUD = $"../HUD"

var is_crouching = false
var movement_direction = 0
var facing_direction = 1

var current_animation_state: CharacterState = CharacterState.IDLE

var projectile_scene = preload("res://scenes/utils/projectile/projectile.tscn")
var is_attacking = false
var attack_timer := 0.0
var attack_threshold := 0.2

var is_killable = true


func _input(event: InputEvent) -> void:
	if !(event is InputEventKey):
		return

	var letter = char(event.unicode) if event.unicode > 0 else event.as_text()

	if event.is_released():
		is_attacking = false
		match letter.to_lower():
			"j":
				toggleCrouchCollision(false)
			"h":
				if movement_direction == -1:
					movement_direction = 0
			"l":
				if movement_direction == 1:
					movement_direction = 0
		return

	if event.is_pressed():
		match Global.current_mode:
			Global.CurrentMode.NORMAL:
				handle_normal_mode_input(letter)
			Global.CurrentMode.INSERT:
				handle_insert_mode_input(letter)
			Global.CurrentMode.CNORMAL:
				handle_command_normal_mode_input(letter)


func _physics_process(delta) -> void:
	if is_attacking:
		current_animation_state = CharacterState.CAST
		attack_timer = attack_threshold
	elif attack_timer > 0.0:
		attack_timer -= delta
		current_animation_state = CharacterState.CAST
	elif is_moving():
		handle_movement()
	elif is_on_floor() and self.velocity.y == 0 and !is_crouching:
		current_animation_state = CharacterState.IDLE
		self.velocity.x = move_toward(self.velocity.x, 0, movement_speed)
	else:
		self.velocity.x = 0

	handle_gravity(delta)
	update_animation()
	move_and_slide()


func is_moving() -> bool:
	return movement_direction == 1 or movement_direction == -1


func handle_movement() -> void:
	anim.flip_h = movement_direction == -1
	self.velocity.x = movement_direction * movement_speed
	if self.velocity.y == 0:
		current_animation_state = CharacterState.RUN


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity = jump_gravity if self.velocity.y < 0.0 else fall_gravity
		self.velocity.y += gravity * delta
		if self.velocity.y > 0:
			current_animation_state = CharacterState.FALL


func update_animation() -> void:
	match current_animation_state:
		CharacterState.IDLE:
			anim.play("Idle")
		CharacterState.RUN:
			anim.play("Run")
		CharacterState.JUMP:
			anim.play("Jump")
		CharacterState.CROUCH:
			anim.play("Crouch")
		CharacterState.CAST:
			anim.play("Cast")
		CharacterState.FALL:
			anim.play("Fall")


func toggleCrouchCollision(_is_crouching: bool) -> void:
	is_crouching = _is_crouching
	$StandingCollisionShape.disabled = _is_crouching
	$CrouchingCollisionShape.disabled = !_is_crouching


func handle_insert_mode_input(letter: String) -> void:
	if letter == "Escape":
		change_mode(Global.CurrentMode.NORMAL)
		return
	is_attacking = true
	spawn_projectile(letter)


func handle_normal_mode_input(letter: String) -> void:
	match letter:
		"i", "a":
			change_mode(Global.CurrentMode.INSERT)
		":":
			change_mode(Global.CurrentMode.CNORMAL)
			HUD.update_cli(":")
		"k":
			handle_jump()
		"j":
			handle_crouch()
		"h":
			movement_direction = -1
			facing_direction = -1
		"l":
			movement_direction = 1
			facing_direction = 1


func handle_command_normal_mode_input(letter: String) -> void:
	if letter == "Enter":
		change_mode(Global.CurrentMode.NORMAL)
		return
	HUD.update_cli(letter)


func handle_jump() -> void:
	if is_on_floor():
		self.velocity.y = jump_velocity
		current_animation_state = CharacterState.JUMP


func handle_crouch() -> void:
	if is_on_floor():
		current_animation_state = CharacterState.CROUCH
		toggleCrouchCollision(true)
	self.velocity.x = 0


func spawn_projectile(letter: String) -> void:
	var projectile = projectile_scene.instantiate()
	var offset_x = 12 if facing_direction == 1 else -15
	projectile.init(letter, self.position + Vector2(offset_x, -3), facing_direction)
	owner.add_child(projectile)


func change_mode(new_mode: Global.CurrentMode) -> void:
	Global.current_mode = new_mode
	HUD.update_mode()

func coin_collected(amount:int )->void:
	Global.collected_coins += amount
	HUD.update_coins()

func die():
	if Global.current_checkpoint != null and Global.player_health > 0:
		Global.player_health -= 1
		self.position = Global.current_checkpoint.global_position
		HUD.update()
		is_killable = false
		await get_tree().create_timer(1.0).timeout
		is_killable = true
