extends Area2D

@onready var anim := $AnimatedSprite2D

var following_body = null
var speed := 100

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	self.visible = false

func _process(delta: float) -> void:
	if following_body != null:
		anim.play("Pulse")
		var distance: Vector2 = following_body.position - self.position
		var direction := (distance).normalized()
		self.position += speed * direction * delta
		if distance < Vector2(10, 10):
			self.queue_free()

# --------------------
# Public Methods
# --------------------

func start_following_body(body: CharacterBody2D) -> void:
	self.visible = true
	following_body = body

# --------------------
# Private methods
# --------------------
