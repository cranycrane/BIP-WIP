extends Node3D

@onready var dialogue_box = $DialogueControl/BoxContainer/DialogueBox

# Define the key to trigger the dialogue
const INTERACT_KEY = "ui_interact"

# Signal to connect when the player enters the area
signal player_entered

# Variable to keep track of the player inside the area
var player_in_area = null

func _ready():
	dialogue_box.add_theme_font_size_override("font_size", 128)

func _process(delta):
	# Check if the player is in the area and the interact key is pressed
	if player_in_area and Input.is_action_just_pressed(INTERACT_KEY):
		start_dialogue()

func _on_area_3d_body_entered(body):
	# Check if the entered body is the player
	if body.name == "Player":
		player_in_area = body
		print("PLAYER ENTERED")
		emit_signal("player_entered", body)

func _on_area_3d_body_exited(body):
	# Clear the player reference if they exit the area
	if body == player_in_area:
		player_in_area = null

func start_dialogue():
	print("Dialogue started")
	dialogue_box.start('START')
