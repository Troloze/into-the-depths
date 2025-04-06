extends Node

const QUESTIONS:Array = [
	"Between these, which one is your favorite color?",
	"Which one of these would you rather have as a pet?",
	"Between these, what is your favorite number?",
	"Which would you rather have for dinner?",
	"How do you think am I?",
	"How often do you brush your teeth?",
	"Glibity blip blop?",
	"Which of these books would you rather read?",
	"...",
	"In one word, how would you describe your mood right now?",
	"How often do you pray?",
	"How many angels do you think there are out there?",
	"What kind of weather do you prefer?",
	"Between these music genres, which would you rather listen to?",
	"Between these movie genres, which would you rather watch?",
	"Between these, which way is it more likely that you'd try to get away with murder with?"
]

const OPTIONS:Array[Array] = [
	["Red", "Blue", "Green", "Magenta", "Cyan", "Yellow", "Black", "White", "Brown", "Pink"],
	["Dog", "Cat", "Rabbit", "Fruit Fly", "Ghost", "The Cave Goblin", "Cow", "Giraffe", "Sea Slug", "Metal Slug"],
	["36", "63", "363", "436", "43", "34", "346", "643", "364", "634"],
	["Burguer", "Salad", "Breakfast", "Raw Onions", "Lunch", "Limestone", "French Fries", "Your Mother", "Jelly Beans", "Yogurt"],
	["36", "63", "363", "436", "43", "34", "346", "643", "364", "634"],
	["Once a day", "Twice a day", "Once a week", "Twice a week", "Once a month", "Twice a month", "Never", "Always", "Thrice a week", "Thrice a day"],
	["Boop!", "Blorb...", "Beep Boop!", "Glorg...", "Pip Pop?", "Pop!", "Pip Bop?", "Glorg Blorg...", "Glorp...", "Bop!"],
	["The Last Potato", "The Holy Bible", "The Unholy Bibble", "Necronomicon", "The Adventures of Mr. Mister", "Hex Curses For Dummies", "The Weeper", "Crashing Down on Ghileytown", "How to not suck at cooking", "The Depths' Bestiary"],
	["..?", "?", "..!", "!", "...", ".-.", "..", ".", "?!", "!?"],
	["Meh", "Ok", "Sad", "Happy", "Hungry", "Murderous", "Annoyed", "Overwhelmed", "Joyous", "Terrific"],
	["Once a day", "Twice a day", "Once a week", "Twice a week", "Once a month", "Twice a month", "Never", "Always", "Thrice a week", "Thrice a day"],
	["At least one", "At least two", "At least three", "More than 50", "Less than 50", "A lot", "Not a lot", "None", "More than 100", "More than 1000"],
	["Sunny and Breezy", "Cloudy and Cool", "Dry and Hot", "Mild", "Heavy Rain", "Humid and Hot", "Dry and Cold", "Humid and Cold", "Cloudy and Slight Rain", "Hell"],
	["Pop", "RnB", "Funk", "Jazz", "Classical", "Orchestral", "Game Music", "Anime Music", "Silence", "Reggae"],
	["Horror", "Thriller", "Action", "Adventure", "Romance", "Mystery", "Documentary", "Comedy", "Drama", "None"],
	["Digging a hole", "Throwing on the river", "Dissolving the Body", "Dismembering it and eating it", "Making it look like suicide", "Pretending that the body isn't dead", "Framing someone", "Not commiting murder", "Feeding it to pigs", "Paying someone to deal with it for me"]
]

var question_count:int
var answers:Array[int] = []
var answered_id:Array[int] = []
var wrong_answers:Array[Array] = []
var last_3_answered:Array[int] = [-1, -1, -1]
var l3a_pos = 0
var answered_count:int = 0

func _init() -> void:
	question_count = len(QUESTIONS)
	for i in range(0, question_count):
		answers.append(-1)
		wrong_answers.append([])

func reset():
	answers = []
	for i in range(0, question_count):
		answers.append(-1)
	answered_id = []
	last_3_answered = [-1, -1, -1]
	l3a_pos = 0
	answered_count = 0

func get_question(is_evil:bool = false)->Dictionary:
	var q
	var ans
	print (answered_count, is_evil)
	if is_evil:
		if (answered_count < 4): 
			return {"Question": -1, "Answer": [-1, -1, -1, -1], "Correct": -1}
		q = randi() % len(answered_id)
		while answered_id[q] in last_3_answered:
			q = (q + 1) % len(answered_id)
		ans = get_answers(answered_id[q])
		update_last_answer(answered_id[q])
		return {"Question": answered_id[q], "Answer": ans, "Correct": answers[answered_id[q]]}
	if answered_count < 4:
		q = randi() % question_count
		while answers[q] != -1:
			q = (q + 1) % question_count
		ans = get_answers(q)
		update_last_answer(q)
		return {"Question": q, "Answer": ans, "Correct": answers[q]}
	if randi()%3 == 0:
		q = randi() % len(answered_id)
		q = answered_id[q]
		while q in last_3_answered:
			q = (q + 1) % len(answered_id)
		ans = get_answers(q)
		update_last_answer(q)
		return {"Question": q, "Answer": ans, "Correct": answers[q]}
	q = randi() % question_count
	while q in last_3_answered:
		q = (q + 1) % len(answered_id)
	ans = get_answers(q)
	update_last_answer(q)
	return {"Question": q, "Answer": ans, "Correct": answers[q]}

func get_answers(q:int):
	var a_list = []
	for i in range(0, 4):
		var c_a = randi()%10
		while c_a in a_list:
			c_a = randi()%10
		a_list.append(c_a)
	if answers[q] != -1 and not (answers[q] in a_list):
		a_list[0] = answers[q]
	return a_list

func update_last_answer(q:int):
	last_3_answered[l3a_pos] = q
	l3a_pos = (l3a_pos + 1) % 3
	pass

func get_question_string(id:int)->String:
	return QUESTIONS[id]

func get_answer_string(q_id:int, a_id:int)->String:
	return OPTIONS[q_id][a_id]

func set_answer(q_id:int, a_id:int, is_evil:bool=false):
	answered_count += 1
	answered_id.append(q_id)
	answers[q_id] = a_id
