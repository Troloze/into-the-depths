extends Node2D

const main_game = preload("res://Scenes/MainGame.tscn")

var death_descriptors = [
	"Gravity may not be a monster, but it will kill you",
	"It is more afraid of you than you are of it",
	"Yoink!",
	"Don't be incoherent around angels, they hate change, so make sure to only use the same answers. Don't leave them waiting though.",
	"Fallen angels like pranking people, saying the wrong answer will get them confused and make them leave",
	"The Möth seekth the light, use it sparingly.",
	"Your hands are hurt from all the dropping and grabbing, you can't leave now."
]

@export
var Grav:Texture2D
@export
var Moth:Texture2D
@export
var Angl:Texture2D
@export
var Fall:Texture2D
@export
var Giga:Texture2D
@export
var Burn:Texture2D

func _ready():
	var death = GlobalDefs.cause_of_death
	var desc = ""
	match death:
		"Gravity":
			desc = death_descriptors[0]
			get_node("Sprite2D2").texture = Grav
		"Mothman":
			desc = death_descriptors[5]
			get_node("Sprite2D2").texture = Moth
		"Angel":
			desc = death_descriptors[3]
			get_node("Sprite2D2").texture = Angl
		"Fallen":
			desc = death_descriptors[4]
			get_node("Sprite2D2").texture = Fall
		"Giga":
			desc = death_descriptors[2]
			get_node("Sprite2D2").texture = Giga
		"Burn":
			desc = death_descriptors[6]
			get_node("Sprite2D2").texture = Burn
	get_node("Control/Label").text = desc


func _process(_delta: float) -> void:
	var press:bool = Input.is_action_just_pressed("Down") or Input.is_action_just_pressed("Up") 
	press = press or Input.is_action_just_pressed("Drop") or Input.is_action_just_pressed("Interact")
	press = press or Input.is_action_just_pressed("Flash")
	
	if press:
		get_tree().change_scene_to_packed(main_game)
