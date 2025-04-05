extends Node2D


const box = preload("res://Scenes/clickable_option.tscn")

@export
var is_fallen = false
var is_answered = false

var q_id:int
var a_id:int
var options:Array = []
var frame_1:bool = true
var box_arr:Array = []
var has_options = false

const opt_pos:Array[Vector2] = [
	Vector2(-300, 200), Vector2(-200, 300), Vector2(200, 300), Vector2(300, 200)
]

func begin_stuff():
	get_node("AnimationPlayer").current_animation = "spawn"

func _process(_delta: float) -> void:
	if frame_1:
		begin_stuff()
		frame_1 = false
	if has_options:
		for i in range(4):
			box_arr[i].set_button_position(opt_pos[i] + Vector2.UP * sin(Time.get_ticks_msec()*0.003 + i) * 3)
			if PlayerStatus.is_flashlight:
				box_arr[i].show_button()
			else:
				box_arr[i].hide_button()
	if PlayerStatus.is_flashlight:
		visible = true
	else:
		visible = false

func remove_buttons():
	has_options = false
	for i in range(len(box_arr)):
		box_arr[i].hide_button()
		box_arr[i].queue_free
		box_arr[i] = null
	box_arr = []
	is_answered = false

func prepare_questions():
	var q = AngelQuestionHandler.get_question()
	q_id = q.Question
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
		add_child(b_inst)
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
	GlobalDefs.death()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		get_node("Timer").start()
	if anim_name == "good answer":
		queue_free()

func _on_timer_timeout() -> void:
	if not is_answered:
		get_node("AnimationPlayer").current_animation = "too long"
