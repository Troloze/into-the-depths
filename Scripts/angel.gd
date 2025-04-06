extends Node2D


signal onDespawn(id:int)

const box = preload("res://Scenes/clickable_option.tscn")

var monster_id = -1

@export
var is_fallen = false
var is_answered = false

var q_id:int
var a_id:int
var options:Array = []
var box_arr:Array = []
var has_options = false

var invisible_velocity_multiplier = 5
var velocity = 1700
var threshold = 50

var init_threshold = 200
var is_init = false

const opt_pos:Array[Vector2] = [
	Vector2(-400, 150), Vector2(-250, 250), Vector2(250, 250), Vector2(400, 150)
]

func _ready():
	get_node("ControlNode/Label").visible = false

var displacement = 0
func begin_stuff():
	get_node("Timer").start()
	get_node("AnimationPlayer").play("spawn")

func _process(_delta: float) -> void:
	if move_towards_player(_delta) < init_threshold and not is_init:
		begin_stuff()
		is_init = true
	
	if has_options:
		for i in range(4):
			box_arr[i].set_button_position(opt_pos[i] + Vector2.UP * sin(Time.get_ticks_msec()*0.003 + i) * 3)
			if PlayerStatus.is_flashlight:
				box_arr[i].show_button()
			else:
				box_arr[i].hide_button()
	
	if PlayerStatus.is_flashlight:
		visible = true
		if has_options:
			get_node("ControlNode/Label").visible = true
	else:
		visible = false
		if has_options:
			get_node("ControlNode/Label").visible = false
		
func move_towards_player(_delta:float):
	var speed = velocity
	if not is_init:
		speed *= invisible_velocity_multiplier
	var par_inst:ParallaxInstance = get_node("ParallaxInstance")
	var target = PlayerStatus.current_pos
	var offset = par_inst.y_world_position - target
	var displacement = min(speed, max(threshold, abs(offset)) - threshold) 
	par_inst.y_world_position -= offset/abs(offset) * displacement * _delta
	var ctr_n:Node2D = get_node("ControlNode")
	var ctr_n_offset = ctr_n.global_position.y - target
	var ctr_n_displacement = min(speed, max(threshold, abs(ctr_n_offset)) - threshold) 
	ctr_n.position.y -= ctr_n_offset/abs(ctr_n_offset) * ctr_n_displacement * _delta
	return abs(ctr_n_offset)


func remove_buttons():
	has_options = false
	for i in range(len(box_arr)):
		box_arr[i].hide_button()
		box_arr[i].queue_free
		box_arr[i] = null
	box_arr = []
	get_node("ControlNode/Label").visible = false
	is_answered = false

func prepare_questions():
	var q = AngelQuestionHandler.get_question(is_fallen)
	q_id = q.Question
	get_node("ControlNode/Label/Text").text = AngelQuestionHandler.get_question_string(q_id)
	print(AngelQuestionHandler.get_question_string(q_id))
	a_id = q.Correct
	options = q.Answer
	options.shuffle()

func generate_answer_boxes():
	for i in range(len(options)):
		var b_inst = box.instantiate()
		b_inst.set_option(AngelQuestionHandler.get_answer_string(q_id, options[i]), options[i])
		b_inst.set_button_position(opt_pos[i])
		b_inst.answer_selected.connect(_answer_selected)
		b_inst.hide_button()
		get_node("ControlNode").add_child(b_inst)
		box_arr.append(b_inst)
	has_options = true

func _answer_selected(given_a_id:int):
	if is_answered:
		return
	is_answered = true
	if a_id == -1:
		AngelQuestionHandler.set_answer(q_id, given_a_id)
		satisfaction()
		return
	if a_id == given_a_id:
		if is_fallen:
			disappointment()
		else:
			satisfaction()
	else:
		if is_fallen:
			satisfaction()
		else:
			disappointment()

func satisfaction():
	get_node("AnimationPlayer").current_animation = "good answer"

func disappointment():
	get_node("AnimationPlayer").current_animation = "bad answer"

func and_thy_punishment_is():
	if not is_fallen:
		GlobalDefs.death("Angel")
	else:
		GlobalDefs.death("Fallen")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "good answer":
		onDespawn.emit(monster_id)
		queue_free()

func _on_timer_timeout() -> void:
	if not is_answered:
		get_node("AnimationPlayer").play("too long")
