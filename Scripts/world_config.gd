extends Node2D

const ANGEL = preload("res://Scenes/angel.tscn")
const GIGA = preload("res://Scenes/gigalan.tscn")
const FALLEN = preload("res://Scenes/fallen.tscn")
const WATCHER = preload("res://Scenes/watcher.tscn")

const monster_bestiary:Dictionary = {
	"Angel": ANGEL,
	"Fallen": FALLEN,
	"Giga": GIGA,
	"Watcher": WATCHER,
	"Raven": null,
	"Mimic": null
}

const ignore = ["Mimic", "Raven"]

var monster_spawn_data:Dictionary = {
	"Angel": {"ID": 0, "Mask": 0b00001, "Wait": 6, "Priority": 4, "Name": "Angel"},
	"Giga": {"ID": 1, "Mask": 0b10110, "Wait": 8, "Priority": -2, "Name": "Giga"},
	"Watcher": {"ID": 2, "Mask": 0b00110, "Wait": 8, "Priority": 1, "Name": "Watcher"},
	"Raven": {"ID": 3, "Mask": 0b01110, "Wait": 9, "Priority": 3, "Name": "Raven"},
	"Mimic": {"ID": 4, "Mask": 0b10010, "Wait": 20, "Priority": 0, "Name": "Mimic"}
}

const monster_cooldown_multiplier_range:Vector2 = Vector2(0.8, 1.5)

@export 
var rope_end = 12000

@export
var monster_spawn_threshold = 1000

var rope_start = -500
const CEILING = preload("res://Scenes/Ceiling.tscn")
const GROUND = preload("res://Scenes/Floor.tscn")
var active_monster:Dictionary = {}
var monster_buffer:Array = []
var monster_id = 0

func _init()->void:
	GlobalDefs.max_pos = rope_end
	GlobalDefs.min_pos = rope_start
	GlobalDefs.gigalan_range = Vector2(rope_start + 2000, rope_end - 3000)
	GlobalDefs.watcher_range = Vector2(rope_start + 3000, rope_end - 2000)

func _ready()->void:
	var ceiling = CEILING.instantiate()
	ceiling.position.y = 600
	add_child(ceiling)
	var ground = GROUND.instantiate()
	ground.position.y = rope_end
	add_child(ground)
	for i in monster_spawn_data.values():
		var t:Timer = Timer.new()
		t.one_shot = true
		t.name = i["Name"]
		i["Timer"] = t
		var callback
		match i["Name"]:
			"Angel":
				callback = _angel_timeout
			"Giga":
				callback = _giga_timeout
			"Mimic":
				callback = _mimic_timeout
			"Raven":
				callback = _raven_timeout
			"Watcher":
				callback = _watcher_timeout
		t.timeout.connect(callback)
		add_child(t)
		var time = i["Wait"] * spawn_time_randomizer()
		t.start(time)

func _process(_delta:float)->void:
	pass
	spawn_handler()
	#print(active_monster)

func spawn_handler():
	if PlayerStatus.current_pos < monster_spawn_threshold:
		return
	if len(monster_buffer) == 0:
		return
	var monster_flag = 0
	for i in active_monster.values():
		monster_flag += 2**monster_spawn_data[i]["ID"]
	for i in range(len(monster_buffer)):
		var name = monster_buffer[i]["Name"]
		var monster_data = monster_spawn_data[name]
		if (monster_flag & monster_data["Mask"]) != 0:
			continue
		_inst_monster(name)
		remove_from_buffer(i)
		break


func custom_buffer_sorter(a, b):
	return a["Priority"] < b["Priority"]

func add_to_buffer(monster):
	for i in monster_buffer:
		if monster == i["Name"]:
			return
	for i in active_monster.values():
		if monster == i:
			return
	monster_buffer.append({"Name":monster, "Priority":monster_spawn_data[monster]["Priority"]})
	monster_buffer.sort_custom(custom_buffer_sorter)

func remove_from_buffer(id):
	monster_buffer.pop_at(id)
	for i in monster_buffer:
		i["Priority"] += 1

func spawn_time_randomizer():
	return remap(randf(), 0, 1, monster_cooldown_multiplier_range.x, monster_cooldown_multiplier_range.y)

func _inst_monster(monster):
	print(monster)
	if monster in ignore:
		return
	var res = monster_bestiary[monster]
	if monster == "Angel":
		if AngelQuestionHandler.answered_count > 5:
			if randi()%2 == 0:
				res = monster_bestiary["Fallen"]
	var new_monster = res.instantiate()
	add_child(new_monster)
	new_monster.onDespawn.connect(_on_monster_despawn)
	new_monster.monster_id = monster_id
	active_monster[monster_id] = monster
	monster_id += 1

func _on_monster_despawn(id:int):
	active_monster.erase(id)

func _angel_timeout():
	var monster_data = monster_spawn_data["Angel"]
	var delay = monster_data["Wait"]
	monster_data["Timer"].start(delay * spawn_time_randomizer())
	if randf() >= .8:
		return
	add_to_buffer("Angel")

func _giga_timeout():
	var monster_data = monster_spawn_data["Giga"]
	var delay = monster_data["Wait"]
	monster_data["Timer"].start(delay * spawn_time_randomizer())
	if randf() >= .5:
		return
	add_to_buffer("Giga")

func _watcher_timeout():
	var monster_data = monster_spawn_data["Watcher"]
	var delay = monster_data["Wait"]
	monster_data["Timer"].start(delay * spawn_time_randomizer())
	if randf() >= .4:
		return
	add_to_buffer("Watcher")

func _raven_timeout():
	var monster_data = monster_spawn_data["Raven"]
	var delay = monster_data["Wait"]
	monster_data["Timer"].start(delay * spawn_time_randomizer())
	if randf() >= .7:
		return
	add_to_buffer("Raven")

func _mimic_timeout():
	var monster_data = monster_spawn_data["Mimic"]
	var delay = monster_data["Wait"]
	monster_data["Timer"].start(delay * spawn_time_randomizer())
	if randf() >= .5:
		return
	add_to_buffer("Mimic")
