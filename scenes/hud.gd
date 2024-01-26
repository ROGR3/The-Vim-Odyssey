extends CanvasLayer

@onready var healthLabel = $Health/Label
@onready var coinsLabel = $Coins/Label
@onready var cliLabel = $CLI/Label
@onready var modeLabel = $Mode/Label

var written_command = ""


func _ready() -> void:
	update()


func update():
	update_health()
	update_cli()
	update_mode()
	update_coins()


func update_health():
	healthLabel.text = str(Global.player_health)


func update_cli(letter: String = ""):
	if Global.current_mode == Global.CurrentMode.CNORMAL and letter:
		written_command += letter
	else:
		written_command = ""
	cliLabel.text = str(written_command)


func update_mode():
	modeLabel.text = "--" + create_string_from_enum(Global.CurrentMode, Global.current_mode) + "--"

func update_coins():
	coinsLabel.text = str(Global.collected_coins)
	

func create_string_from_enum(_enum, _value):
	var keys = _enum.keys()
	return str(keys[_value])

