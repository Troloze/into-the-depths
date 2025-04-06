extends Node

const HORIZON_DISTANCE = 10
var min_pos:float
var max_pos:float

var gigalan_range:Vector2
var watcher_range:Vector2
var cause_of_death

func death(cause:String):
	cause_of_death = cause
	AngelQuestionHandler.reset()
	GlobalSceneChanger.change_scene("Mortis")

func glory():
	GlobalSceneChanger.change_scene("Win")
