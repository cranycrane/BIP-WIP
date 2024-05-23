extends Node2D

var score: int = 0
var lives: int = 3  # Starting number of lives
@export var max_lives: int = 5  # Maximum number of lives the player can have

@onready var heart_container = $HeartContainer
@onready var death_screen = $DeathScreen
@onready var restart_button = $DeathScreen/RestartButton

func _ready():
	set_score(0)

func set_score(value):
	score = value
	update_score_display()

func add_score(amount = 1):
	score += amount
	update_score_display()

func update_score_display():
	get_node("Display/SCORE").text = "SCORE: " + str(score)

func update_lives_display(current_lives):
	if current_lives <= 0:
		show_death_screen()
		
	# Clear all heart icons
	print("Getting hit, lives: %s" % current_lives)
	for heart in heart_container.get_children():
		heart.queue_free()
	
	# Add heart icons based on the current number of lives
	for i in range(current_lives):
		var heart = TextureRect.new()
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		heart.texture = preload("res://art/heart.png")  # Set the path to your heart textu
		heart_container.add_child(heart)

func _on_player_player_hit(current_lives):
	update_lives_display(current_lives)

# Death behaviour
func show_death_screen():
	death_screen.show()
	get_tree().paused = true

func _on_restart_button_pressed():
	print("AHOJ")
	get_tree().paused = false
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
