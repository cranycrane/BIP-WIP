# NPC.gd
extends Node3D

@export var player: NodePath
@export var message = "Hello world"

var player_node: Node3D

func _ready():
	player_node = get_node(player)
	$Label3D.visible = false
	$Label3D.text = message
	
func _process(delta):
	if $Label3D.visible:
		_rotate_label_towards_player()

func _on_area_3d_body_entered(body):
	if body == player_node:
		$Label3D.visible = true
		_rotate_label_towards_player()

func _on_area_3d_body_exited(body):
	if body == player_node:
		$Label3D.visible = false

func _rotate_label_towards_player():
	var player_position = player_node.global_transform.origin
	var label_position = $Label3D.global_transform.origin

	# Calculate the direction to the player, ignoring the Y axis
	var direction = (player_position - label_position)
	direction.y = 0
	direction = direction.normalized()

	$Label3D.look_at(label_position + direction, Vector3.UP)

	# Rotate the label by 180 degrees around the Y axis
	$Label3D.rotate_y(deg_to_rad(180))
