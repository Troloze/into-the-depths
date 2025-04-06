extends Control

var a_id:int

signal answer_selected(a_id:int)


func set_button_position(pos: Vector2):
	var bt = get_node("Button")
	bt.position = pos - bt.size/2

func hide_button():
	var bt = get_node("Button")
	bt.visible = false

func show_button():
	var bt = get_node("Button")
	bt.visible = true

func set_option(q:String, answer_id:int):
	a_id = answer_id
	get_node("Button").text = q

func _on_button_pressed() -> void:
	answer_selected.emit(a_id)
