extends Node2D



const flash_max = 1500
const flash_rate = 100
const flash_reduce_rate = 75
const flash_pop = 50
var flash_meter = 0

func _ready():
	PlayerStatus.flash.connect(flashlight_state)
	get_node("ParallaxInstance").visible = false

func _process(delta: float) -> void:
	get_node("ParallaxInstance").y_world_position = PlayerStatus.current_pos
	if PlayerStatus.is_flashlight:
		flash_meter += delta * flash_rate
	else:
		flash_meter -= delta * flash_reduce_rate
		if flash_meter < 0:
			flash_meter = 0
	if flash_meter >= flash_max:
		activate()
	flash_visibility_handler()

func flash_visibility_handler()->void:
	if PlayerStatus.is_flashlight:
		get_node("ParallaxInstance/Flash").visible = true
		get_node("ParallaxInstance/Unflash").visible = false
	else:
		get_node("ParallaxInstance/Flash").visible = false
		get_node("ParallaxInstance/Unflash").visible = true
	pass

func flashlight_state(state:bool) -> void:
	if state:
		flash_meter += flash_pop
	pass

func activate():
	get_node("AnimationPlayer").current_animation = "Attack"
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GlobalDefs.death("Mothman")
