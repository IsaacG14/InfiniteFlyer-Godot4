extends Node
var high_score = 0
var high_distance = 0
var score_file = "user://hs.dat"
var distance_file = "user://ds.dat"

func _ready():
	load_data()
func load_data():
	if FileAccess.file_exists(distance_file):
		var file = FileAccess.open(distance_file,FileAccess.READ)
		high_distance = file.get_var()
	else:
		high_distance = 0
	if FileAccess.file_exists(score_file):
		var file = FileAccess.open(score_file,FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0
func save_score():
	var file = FileAccess.open(score_file, FileAccess.WRITE)
	file.store_var(high_score)
func save_distance():
	var file = FileAccess.open(distance_file, FileAccess.WRITE)
	file.store_var(high_distance)
