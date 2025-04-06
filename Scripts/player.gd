extends Node2D


@export
var speed:float = 600


var max_y:float
var min_y:float

@export 
var boundary_threshold:float = 300

var is_free_fall:bool = false
var is_holding_on:bool = false
var is_startled:bool = false
var no_grip:bool = false

var grip_buffer:bool = false
var drop_buffer:bool = false

var grounded:bool = false
var ceiled:bool = false

var is_ascent:bool = false
var cutscene:bool = true
var end:bool = false

const gravity:float = 2500
const terminal_velocity:float = 5000
const lethal_velocity:float = 3500

var curr_speed:float = 0
const grip_leniency:float = 1000
const grip_strenght:float = 2000

var can_grip:bool = false
var grip_integrity:float = 5000

func _ready()->void:
	process_priority = -1
	get_node("AnimationPlayer").current_animation = "start"
	PlayerStatus.watcher_startle.connect(_on_startle)

func _init() -> void:
	PlayerStatus.reset()
	PlayerStatus.current_pos = 0
	max_y = GlobalDefs.max_pos
	min_y = GlobalDefs.min_pos

func _on_startle():
	start_falling(true)

func _process(delta: float) -> void:
	if cutscene:
		PlayerStatus.current_pos = position.y
		return
	if end:
		position += Vector2.DOWN * -1 * delta * speed
		PlayerStatus.current_pos = position.y
		return
	var axis = Input.get_axis("Up", "Down")
	var flash = Input.is_action_just_pressed("Flash") 
	var drop = Input.is_action_just_pressed("Drop")
	if drop and not drop_buffer:
		get_node("DropBufferTimer").start()
		drop_buffer=true
	if not is_free_fall:
		if drop_buffer:
			start_falling()
		else:
			position += Vector2.DOWN * axis * delta * speed
			handle_movement_boundaries()
	free_fall_handler(delta)
	if flash:
		PlayerStatus.toggle_flash()
	if PlayerStatus.is_flashlight:
		get_node("Fade3").visible = false
	else: 
		get_node("Fade3").visible = true
	PlayerStatus.current_pos = position.y
	PlayerStatus.is_falling = is_free_fall
	#print(position.y)
	PlayerStatus.grip_integrity = grip_integrity
	

func handle_movement_boundaries()->void:
	if position.y >= max_y - boundary_threshold:
		position.y = max_y - boundary_threshold
		on_grounded()
	else:
		grounded = false
	if position.y <= min_y + boundary_threshold:
		position.y = min_y + boundary_threshold
		on_ceiled()
	else:
		ceiled = false
	pass

func free_fall_handler(delta)->void:
	if not is_free_fall:
		return
	if no_grip:
		curr_speed = min(terminal_velocity, curr_speed + gravity * delta)
		position += Vector2.DOWN * delta * curr_speed
		if (position.y >= max_y - boundary_threshold):
			if curr_speed >= lethal_velocity:
				GlobalDefs.death("Gravity")
			curr_speed = 0
			position.y = max_y - boundary_threshold
			is_free_fall = false
			is_startled = false
			is_holding_on = false
			drop_buffer = false
			grip_buffer = false
			on_grounded()
		return
	if Input.is_action_just_pressed("Drop") and not is_holding_on:
		get_node("GripBufferTimer").start()
		grip_buffer = true
	if grip_buffer and (not is_startled) and can_grip:
		is_holding_on = true
		grip_buffer = false
	if not is_holding_on:
		curr_speed = min(terminal_velocity, curr_speed + gravity * delta)
	else: 
		grip_integrity -= (max(grip_leniency, curr_speed) - grip_leniency) * delta
		curr_speed = max(0, curr_speed - grip_strenght * delta)
		if curr_speed <= 0:
			is_free_fall = false
			is_holding_on = false
	if grip_integrity <= 0:
		no_grip = true
	position += Vector2.DOWN * delta * curr_speed
	if (position.y >= max_y - boundary_threshold):
		if curr_speed >= lethal_velocity:
			GlobalDefs.death("Gravity")
		curr_speed = 0
		position.y = max_y - boundary_threshold
		is_free_fall = false
		is_holding_on = false
		drop_buffer = false
		grip_buffer = false
		on_grounded()
		
		pass

func on_grounded():
	grounded = true
	if is_ascent:
		return
	is_ascent = true
	cutscene = true
	get_node("AnimationPlayer").current_animation = "fade_black"

func on_ceiled():
	ceiled = true
	if not is_ascent:
		return
	end = true
	get_node("AnimationPlayer").current_animation = "fade_white"

func start_falling(startle=false)->void:
	if startle:
		get_node("StartleTimer").start()
		is_startled = true
	get_node("MinDropTimer").start()
	can_grip = false
	is_free_fall = true

func _on_min_drop_timer_timeout() -> void:
	can_grip = true

func _on_startle_timer_timeout() -> void:
	is_startled = false
	grip_buffer = true

func _on_grip_buffer_timer_timeout() -> void:
	grip_buffer = false

func _on_drop_buffer_timer_timeout() -> void:
	drop_buffer = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_white":
		GlobalDefs.glory()
	cutscene = false
