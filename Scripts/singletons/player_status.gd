extends Node

const CAMERA_DELTA:float = 360

signal flash(is_on:bool)
signal watcher_startle()

var current_pos:float
var is_flashlight:bool = false
var is_falling:bool
var grip_integrity:float

func reset():
	is_flashlight = false

func toggle_flash():
	is_flashlight = not is_flashlight
	flash.emit(is_flashlight)

func startle():
	watcher_startle.emit()
