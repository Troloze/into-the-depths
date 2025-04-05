extends Node

const CAMERA_DELTA:float = 360

var current_pos:float
var is_flashlight:bool = false
var is_falling:bool
var grip_integrity:float

func toggle_flash():
	is_flashlight = not is_flashlight
