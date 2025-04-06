extends Node2D


signal onDespawn()
var monster_id = -1

var hand_sprite = preload("res://Sprites/Gigalan_hand.png")
var face_sprite = preload("res://Sprites/Gigalan_face.png")

var face_node:ParallaxInstance
var hand_node:ParallaxInstance

var hitbox_size = 350
var approach_rate = 0.4
var is_windup = false


func _init() -> void:
	create_face()
	create_hand()

func _process(_delta:float):
	pass
	var p_pos = PlayerStatus.current_pos
	var flash = PlayerStatus.is_flashlight
	if not is_windup:
		hand_node.y_world_position = p_pos
	if flash:
		face_node.visible = true
		hand_node.visible = true
	else:
		face_node.visible = false
		hand_node.visible = false
	if hand_node.distance_to_camera > 1.5:
		hand_node.distance_to_camera -= _delta * approach_rate
	else:
		if not is_windup:
			get_node("Timer").start()
			is_windup = true

func create_hand()->void:
	var hand = ParallaxInstance.new()
	var hand_spr = Sprite2D.new()
	hand_spr.texture = hand_sprite
	hand_spr.scale = Vector2.ONE * 3.5
	hand.add_child(hand_spr)
	add_child(hand)
	hand.visible = false
	hand.distance_to_camera = 8.6
	hand_node = hand

func create_face()->void:
	var face = ParallaxInstance.new()
	var face_spr = Sprite2D.new()
	face.position.y = clamp(PlayerStatus.current_pos + randf() * 1000 - 500, GlobalDefs.gigalan_range.x, GlobalDefs.gigalan_range.y) 
	face.position.x = -400
	face_spr.texture = face_sprite
	face_spr.scale = Vector2.ONE * 18
	face.add_child(face_spr)
	add_child(face)
	face.distance_to_camera = 9.6
	face.visible = false
	face_node = face
	
	


func _on_timer_timeout() -> void:
	var p_pos = PlayerStatus.current_pos
	if abs(hand_node.y_world_position - p_pos) < hitbox_size:
		GlobalDefs.death("Giga")
	onDespawn.emit(monster_id)
	queue_free()
