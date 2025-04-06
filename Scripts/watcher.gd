extends Node2D

signal onDespawn(id:int)
var monster_id = -1

var attention_metter = 0
const attention_threshold = 100
const attention_rate = 200

var dispersion_metter = 0
const dispersion_threshold = 100
const dispersion_rate = 50

var is_active = false
var is_focus = false
var is_flee = false
var ready_to_go = false
var is_loaded = false

func _ready() -> void:
	get_node("AnimationPlayer").play("Spawn")
	get_node("ParallaxInstance").y_world_position = clamp(PlayerStatus.current_pos + randf() * 2000 - 1000, GlobalDefs.watcher_range.x, GlobalDefs.watcher_range.y)

func _process(delta: float) -> void:
	flashlight_handler(delta)
	var flash = PlayerStatus.is_flashlight
	if flash:
		get_node("ParallaxInstance").visible = true
	else:
		if ready_to_go:
			enemy_despawn()
		get_node("ParallaxInstance").visible = false

func flashlight_handler(delta: float) -> void:
	if not is_loaded:
		return
	var flash = PlayerStatus.is_flashlight
	if is_flee:
		return
	if not is_active and flash:
		is_active = true
		get_node("AnimationPlayer").play("Focus")
	if flash and is_focus:
		attention_metter += delta * attention_rate
	if not flash and is_focus:
		dispersion_metter += delta * dispersion_rate
	if dispersion_metter > dispersion_threshold:
		attention_metter = 0
		dispersion_metter = 0
		is_focus = false
		get_node("AnimationPlayer").play("Unfocus")
	if is_focus and attention_metter > attention_threshold:
		get_node("AnimationPlayer").play("Active")
		is_flee = true



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Focus":
		is_focus = true
	if anim_name == "Unfocus":
		is_active = false
	if anim_name == "Active":
		PlayerStatus.startle()
		get_node("AnimationPlayer").play("Flee")
	if anim_name == "Flee":
		enemy_despawn()
	if anim_name == "Spawn":
		is_loaded = true
		get_node("Timer").start()

func enemy_despawn():
	onDespawn.emit(monster_id)
	queue_free()

func _on_timer_timeout() -> void:
	ready_to_go = true
