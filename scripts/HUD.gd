extends Node2D

var coins_collected: int = 0
var curr_lives = 0
var lives: int = 3  # Starting number of lives
var score: int = 0

@export var max_lives: int = 5  # Maximum number of lives the player can have'

@onready var heart_container = $CanvasLayer/HeartContainer
@onready var coin_container = $CanvasLayer/CoinContainer
@onready var death_screen = $DeathScreen
@onready var completed_screen = $CanvasLayer/CompletedScreen

var allowed_pasage = false
var allowed_moving_block = false

func update_lives_display(current_lives):
	curr_lives = current_lives
	if current_lives <= 0:
		show_death_screen()
		return
		
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

func update_scores_display():		
	# Clear all coin
	for coin in coin_container.get_children():
		coin.queue_free()
	
	# Add coin icons based on the current score
	for i in range(coins_collected):
		var coin = TextureRect.new()
		coin.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		coin.texture = preload("res://art/coin.png")
		coin_container.add_child(coin)

func show_death_screen():
	death_screen.show()
	$DeathScreen/DeathScreen/VBoxContainer/Score.text = "Score: " + str((coins_collected + curr_lives)) 
	get_tree().paused = true

func _on_restart_button_pressed():
	get_tree().paused = false
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

func _on_coin_coin_collected():
	coins_collected += 1
	update_scores_display()

func show_completed_screen():
	completed_screen.show()
	$CanvasLayer/CompletedScreen/VBoxContainer/Score.text = "Score: " + str((coins_collected + curr_lives)) 
	get_tree().paused = true

func _on_exit_button_pressed():
	get_tree().quit()



func _on_heart_heart_collected():
	curr_lives += 1
	update_lives_display(curr_lives)
