extends Node

const MAIN_MENU = preload("res://Scenes/Main Menu.tscn")
const CREDITS = preload("res://Scenes/credits.tscn")
const GAME = preload("res://Scenes/MainGame.tscn")
const DEATH = preload("res://Scenes/Mortis.tscn")
const WIN = preload("res://Scenes/Victor.tscn")


func change_scene(scene:String):
	print(scene)
	match scene:
		"Menu":
			get_tree().change_scene_to_packed(MAIN_MENU)
		"Credits":
			get_tree().change_scene_to_packed(CREDITS)
		"Game":
			get_tree().change_scene_to_packed(GAME)
		"Mortis":
			get_tree().change_scene_to_packed(DEATH)
		"Win":
			get_tree().change_scene_to_packed(WIN)
