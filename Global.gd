extends Node

enum CurrentMode {INSERT, VISUAL, NORMAL, CNORMAL}

var current_level: int = 0
var current_checkpoint: Area2D = null

var current_mode: CurrentMode = CurrentMode.NORMAL
var player_health: int = 3
var collected_coins: int = 0

var unlocked_abilities := {CurrentMode.NORMAL: ["j", "h", "k", "l"]}

func respawn_player(player: CharacterBody2D) -> void:
	if current_checkpoint != null and player_health > 0:
		player_health -= 1
		player.position = current_checkpoint.global_position

func unlock_ability(ability: String) -> void:
	unlocked_abilities[CurrentMode.NORMAL].append(ability)

func get_current_level_folder() -> String:
	return "res://scenes/level{level_int}/".format({"level_int": current_level + 1})

func change_scene(scene_path: String) -> void:
	current_checkpoint = null
	call_deferred("_deffered_change_scene", scene_path)

func _deffered_change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
