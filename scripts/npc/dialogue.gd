extends Node3D

@export var dialogue_path : DialogueData

@onready var dialogue_box = $DialogueControl/CanvasLayer/DialogueBox
@onready var interact_hint = $InteractHint

@onready var camera_player = $"../../Player/CameraPivot" #dragged an dropped
# Signal to connect when the player enters the area
signal player_entered

# Variable to keep track of the player inside the area
var player_in_area = null

func _ready():
	dialogue_box.data = dialogue_path

func _process(delta):
	# Check if the player is in the area and the interact key is pressed
	if player_in_area and Input.is_action_just_pressed("ui_dialogue_start") && interact_hint.visible:
		interact_hint.visible = false
		start_dialogue()

func _on_area_3d_body_entered(body):
	# Check if the entered body is the player
	if body.name == "Player":
		interact_hint.visible = true
		player_in_area = body
		print("PLAYER ENTERED")
		emit_signal("player_entered", body)

func _on_area_3d_body_exited(body):
	# Clear the player reference if they exit the area
	if body.name == "Player":
		interact_hint.visible = false
		dialogue_box.stop()
		player_in_area = null

func start_dialogue():
	print("Dialogue started")
	camera_player.cameraTransitionAnimation
	dialogue_box.start('START')
