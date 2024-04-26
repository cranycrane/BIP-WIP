extends Node2D

var score: int = 0

func _ready():
	set_score(0)
	pass

func set_score(value):
	score = value
	update_score_display()

func add_score(amount = 1):
	score += amount
	update_score_display()

func update_score_display():
	get_node("Display/SCORE").text = "SCORE: " + str(score)
