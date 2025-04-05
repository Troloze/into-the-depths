extends Node2D
class_name ParallaxInstance
	
@export 
var distance_to_camera:float = 0

var is_pos_set = false
var y_world_position:float 
var parent_offset:float

var dist_rate

func _ready() -> void:
	if not is_pos_set:
		y_world_position = global_position.y
		parent_offset = position.y - global_position.y
	dist_rate = (distance_to_camera/GlobalDefs.HORIZON_DISTANCE)

func _process(_delta:float)->void:
	var p_pos = PlayerStatus.current_pos
	var offset = p_pos - y_world_position
	
	position.y = y_world_position + parent_offset + offset * dist_rate
	scale = Vector2.ONE * (1 - dist_rate)

func set_world_position(pos:float)->void:
	y_world_position = pos
	is_pos_set = true
