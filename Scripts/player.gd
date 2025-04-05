extends Node2D


@export
var speed:float = 200

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("Up", "Down")
	position += Vector2.DOWN * axis * delta * speed
