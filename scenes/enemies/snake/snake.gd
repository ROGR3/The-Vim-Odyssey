extends Area2D

@export var is_killable := false
@export var hitpoints_text: String = "kill"

@onready var anim := $AnimatedSprite2DLeft
@onready var hitpoints := $Hitpoints

var is_player_detected := false
var is_death := false

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	if not is_killable:
		hitpoints.queue_free()
	else:
		hitpoints.set_starting_text(hitpoints_text)

func _process(_delta: float) -> void:
	if is_death:
		anim.play("Death")
		return
	if is_player_detected:
		anim.play("Attack")
	else:
		anim.play("Idle")

func _on_player_detection_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		is_player_detected = true

func _on_player_detection_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Player":
		is_player_detected = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !is_death:
		body.die(true)

func _on_hitpoints_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectile"):
		hitpoints.hit_by_letter(area.letter_value)
		area.queue_free()
		if hitpoints.is_complete():
			is_death = true
			await anim.animation_finished
			queue_free()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------
