extends Node2D


@export 
var rope_end = 4800
var rope_start = -500
const CEILING = preload("res://Scenes/Ceiling.tscn")
const GROUND = preload("res://Scenes/Floor.tscn")

func _init()->void:
	GlobalDefs.max_pos = rope_end
	GlobalDefs.min_pos = rope_start

func _ready()->void:
	var ceiling = CEILING.instantiate()
	ceiling.position.y = 600
	add_child(ceiling)
	var ground = GROUND.instantiate()
	ground.position.y = rope_end
	add_child(ground)
