extends Node2D

const main_game = preload("res://Scenes/MainGame.tscn")


func _process(delta: float) -> void:
	var press:bool = Input.is_action_just_pressed("Down") or Input.is_action_just_pressed("Up") 
	press = press or Input.is_action_just_pressed("Drop") or Input.is_action_just_pressed("Interact")
	press = press or Input.is_action_just_pressed("Flash")
	
	if press:
		get_tree().change_scene_to_packed(main_game)
