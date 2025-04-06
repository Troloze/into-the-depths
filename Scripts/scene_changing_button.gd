extends TextureRect

@export
var next_scene:String
var once = true
var this_one = false

func _ready():
	gui_input.connect(_on_gui_input)
	get_parent().get_node("AnimationPlayer").animation_finished.connect(_on_animation_end)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_hover_out)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("Interact") and once:
		once = false
		this_one = true
		get_parent().get_node("AnimationPlayer").play("Fade")

func _on_hover():
	scale = Vector2.ONE * 1.1

func _on_hover_out():
	scale = Vector2.ONE

func _on_animation_end(anim_name):
	if anim_name == "Fade" and this_one:
		GlobalSceneChanger.change_scene(next_scene)
