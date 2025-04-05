extends Node2D


var rope_sprite:Texture2D
var end_sprite:Texture2D
@export
var rope_sprite_pixel_size:int = 512
@export
var end_sprite_pixel_size:int = 512

@export
var rope_scale:float = 0.5

@export
var start_height = -500
@export
var end_height = 1500

func _init() -> void:
	rope_sprite = load("res://Sprites/Rope.png")
	end_sprite = load("res://Sprites/Rope.png")
	var count:int = floor((end_height-start_height)/(rope_sprite_pixel_size * rope_scale))
	var curr_y = start_height
	for i in range(count):
		var spr = Sprite2D.new()
		spr.position = Vector2(0, curr_y)
		spr.scale = Vector2.ONE * rope_scale
		spr.texture = rope_sprite
		add_child(spr)
		spr = null
		curr_y += (rope_sprite_pixel_size * rope_scale)
	var spr_end = Sprite2D.new()
	spr_end.texture = end_sprite
	spr_end.position = Vector2(0, curr_y)
	spr_end.scale = Vector2.ONE * rope_scale
	add_child(spr_end)
