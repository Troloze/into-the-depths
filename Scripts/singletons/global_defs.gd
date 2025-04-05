extends Node


const GAME_OVER = preload("res://Scenes/Mortis.tscn")
const WIN = preload("res://Scenes/Victor.tscn")

const HORIZON_DISTANCE = 10
var min_pos:float
var max_pos:float

var cause_of_death

func death():
	get_tree().change_scene_to_packed(GAME_OVER)

func glory():
	get_tree().change_scene_to_packed(WIN)
