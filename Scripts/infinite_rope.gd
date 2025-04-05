extends Node2D


var rope_sprite:Texture2D = preload("res://Sprites/Rope.png")
var end_sprite:Texture2D = preload("res://Sprites/Rope.png")
@export
var rope_sprite_pixel_size:int = 512
@export
var end_sprite_pixel_size:int = 512

@export
var rope_scale:float = 0.5

@export
var rope_distance:float = 0.1

var start_height:float
var end_height:float

func _ready() -> void:
	start_height = GlobalDefs.min_pos
	end_height = GlobalDefs.max_pos
	var count:int = floor((end_height-start_height)/(rope_sprite_pixel_size * rope_scale))
	var curr_y = start_height
	for i in range(count):
		var p_inst = ParallaxInstance.new()
		var spr = Sprite2D.new()
		spr.scale = Vector2.ONE * rope_scale
		spr.texture = rope_sprite
		p_inst.set_world_position(curr_y)
		p_inst.distance_to_camera = rope_distance
		p_inst.add_child(spr)
		add_child(p_inst)
		spr = null
		curr_y += (rope_sprite_pixel_size * rope_scale)
	var p_inst = ParallaxInstance.new()
	var spr = Sprite2D.new()
	spr.scale = Vector2.ONE * rope_scale
	spr.texture = end_sprite
	spr.modulate = Color.RED
	p_inst.set_world_position(curr_y)
	p_inst.distance_to_camera = rope_distance
	p_inst.add_child(spr)
	add_child(p_inst)
	spr = null
