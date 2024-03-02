extends CanvasLayer

@onready var healthLabel := $Health/Label
@onready var coinsLabel := $Coins/Label
@onready var cliLabel := $CLI/Label
@onready var modeLabel := $Mode/Label

var written_command: String = ""

# --------------------
# Built-in Methods
# --------------------

func _ready() -> void:
	update()

func update() -> void:
	__update_health()
	__update_cli()
	__update_mode()
	__update_coins()

# --------------------
# Public Methods
# --------------------

# --------------------
# Private methods
# --------------------

func __update_health() -> void:
	healthLabel.text = str(Global.player_health)

func __update_cli(letter: String="") -> void:
	if Global.current_mode == Global.CurrentMode.CNORMAL and letter:
		written_command += letter
	else:
		written_command = ""
	cliLabel.text = str(written_command)

func __update_mode() -> void:
	modeLabel.text = "--" + __create_string_from_enum(Global.CurrentMode, Global.current_mode) + "--"

func __update_coins() -> void:
	coinsLabel.text = str(Global.collected_coins)

func __create_string_from_enum(_enum: Dictionary, _value: int) -> String:
	var keys := _enum.keys()
	return str(keys[_value])
