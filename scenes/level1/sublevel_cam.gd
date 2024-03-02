extends Camera2D

@onready var player = $".."

func _process(delta):
	if player.global_position.x < 1200 and player.global_position.y < 240:
		self.limit_bottom = 240
	if player.global_position.x > 1200:
		self.limit_bottom = 825

	if player.global_position.x < 1075 and player.global_position.y > 250:
		self.limit_bottom = 640

	if player.global_position.y > 700 and player.global_position.x > 1150:
		self.limit_right = 1800
