extends CharacterBody2D

enum CharacterState {IDLE, RUN, JUMP, CROUCH, CAST, FALL, DIE}
const COINS_TO_HEALTH_RATIO := 100

@export var movement_speed := 100.0
@export var jump_height := 48
@export var jump_time_to_peak := .4
@export var jump_time_to_descent := .3
@export var is_killable := true

var jump_velocity := - ((2.0 * jump_height) / jump_time_to_peak)
var jump_gravity := - ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
var fall_gravity := - ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@onready var anim := $AnimatedSprite2D
@onready var HUD := $"../HUD"
#@onready var letter_tilemap = $"../LetterTileMap"

var move_direction := 0
var facing_direction := 1

var current_animation_state: CharacterState = CharacterState.IDLE

var projectile_scene := preload ("res://scenes/utils/projectile/projectile.tscn")
var is_attacking := false
var attack_timer := 0.0
var attack_threshold := 0.2

var can_jump := true
var coyote_time := .3

# --------------------
# Built-in Methods
# --------------------

func _input(event: InputEvent) -> void:
	if !(event is InputEventKey):
		return

	var letter := char(event.unicode) if event.unicode > 0 else event.as_text()

	if event.is_released():
		is_attacking = false
		match letter.to_lower():
			"h":
				if move_direction == - 1:
					move_direction = 0
			"l":
				if move_direction == 1:
					move_direction = 0
		return

	if event.is_pressed():
		match Global.current_mode:
			Global.CurrentMode.NORMAL:
				__handle_normal_mode_input(letter)
			Global.CurrentMode.INSERT:
				__handle_insert_mode_input(letter)
			Global.CurrentMode.CNORMAL:
				__handle_command_normal_mode_input(letter)

func _physics_process(delta: float) -> void:
	__update_animation()
	if current_animation_state == CharacterState.DIE:
		return

	if is_on_floor() and !can_jump:
		can_jump = true
	elif can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyote_time)

	if is_attacking:
		current_animation_state = CharacterState.CAST
		attack_timer = attack_threshold
	elif attack_timer > 0.0:
		attack_timer -= delta
		current_animation_state = CharacterState.CAST
	elif __is_moving():
		__handle_movement()
	elif is_on_floor() and self.velocity.y == 0:
		current_animation_state = CharacterState.IDLE
		self.velocity.x = move_toward(self.velocity.x, 0, movement_speed)
	else:
		self.velocity.x = 0

	__handle_gravity(delta)
	self.move_and_slide()

func _on_coyote_timer_timeout() -> void:
	can_jump = false

# --------------------
# Public Methods
# --------------------

func coin_collected(amount: int) -> void:
	Global.collected_coins += amount
	if Global.collected_coins >= COINS_TO_HEALTH_RATIO:
		var healthToAdd: int = Global.collected_coins / COINS_TO_HEALTH_RATIO
		Global.collected_coins -= healthToAdd * COINS_TO_HEALTH_RATIO
		Global.player_health += healthToAdd
		HUD.update_health()
	HUD.update_coins()

func heart_collected(amount: int) -> void:
	Global.player_health += amount
	HUD.update_health()

func die(with_anim: bool=false) -> void:
	print("HERE")
	if Global.current_checkpoint and Global.player_health > 0:
		Global.player_health -= 1
		Global.collected_coins /= 2
		if with_anim:
			current_animation_state = CharacterState.DIE
			await anim.animation_finished
			current_animation_state = CharacterState.IDLE

		self.position = Global.current_checkpoint.global_position
		HUD.update()
		if !with_anim:
			is_killable = false
			await get_tree().create_timer(1.0).timeout
			is_killable = true

# --------------------
# Private methods
# --------------------

func __is_moving() -> bool:
	return move_direction == 1 or move_direction == - 1

func __handle_movement() -> void:
	anim.flip_h = move_direction == - 1
	self.velocity.x = move_direction * movement_speed
	if self.velocity.y == 0:
		current_animation_state = CharacterState.RUN

func __handle_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity := jump_gravity if self.velocity.y < 0.0 else fall_gravity
		self.velocity.y += gravity * delta
		if self.velocity.y > 0:
			current_animation_state = CharacterState.FALL

func __update_animation() -> void:
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
		CharacterState.DIE:
			anim.play("Die")

func __handle_insert_mode_input(letter: String) -> void:
	if letter == "Escape":
		__change_mode(Global.CurrentMode.NORMAL)
		return
	is_attacking = true
	__spawn_projectile(letter)

func __handle_normal_mode_input(letter: String) -> void:
	if letter not in Global.unlocked_abilities[Global.CurrentMode.NORMAL]:
		return
	match letter:
		"i", "a":
			__change_mode(Global.CurrentMode.INSERT)
		":":
			__change_mode(Global.CurrentMode.CNORMAL)
			HUD.update_cli(":")
		"k":
			__handle_jump()
		"h":
			move_direction = -1
			facing_direction = -1
		"l":
			move_direction = 1
			facing_direction = 1
		#"w":
		#var new_pos = letter_tilemap.find_beginning_of_word(self.position)
		#self.position = new_pos

func __handle_command_normal_mode_input(letter: String) -> void:
	if letter == "Enter":
		__change_mode(Global.CurrentMode.NORMAL)
		return
	HUD.update_cli(letter)

func __handle_jump() -> void:
	if can_jump:
		self.velocity.y = jump_velocity
		current_animation_state = CharacterState.JUMP

func __spawn_projectile(letter: String) -> void:
	var projectile := projectile_scene.instantiate()
	var offset_x := 12 if facing_direction == 1 else - 15
	projectile.init(letter, self.position + Vector2(offset_x, -3), facing_direction)
	owner.add_child(projectile)

func __change_mode(new_mode: Global.CurrentMode) -> void:
	Global.current_mode = new_mode
	HUD.update_mode()
