extends Node

enum CurrentMode { INSERT, VISUAL, NORMAL, CNORMAL }

var current_level:int = 0
var current_checkpoint = null

var current_mode: CurrentMode = CurrentMode.NORMAL
var player_health:int = 3
var collected_coins:int = 0


func respawn_player(player):
	if current_checkpoint != null and player_health > 0:
		player_health -= 1
		player.position = current_checkpoint.global_position


func get_current_level_folder():
	return "res://scenes/level{level_int}/".format({"level_int": current_level + 1})


func change_scene(scene_path:String) -> void:
	current_checkpoint = null
	call_deferred("_deffered_change_scene", scene_path)
	
func _deffered_change_scene(scene_path:String) -> void:
	get_tree().change_scene_to_file(scene_path)
