extends Node3D

@export var player_node_path : NodePath
@export var minimum_y_level = -10

@onready var hit_screen = $HitScreen

var player = null
var player_spawn_position : Vector3

func _ready():
	player = get_node(player_node_path)
	player_spawn_position = player.global_transform.origin
	hit_screen.visible = false
	
func _process(double):	
	if player.global_transform.origin.y < minimum_y_level:
		player.hit(Vector3.ZERO)
		player.global_transform.origin = player_spawn_position
	

func _on_player_player_hit(current_lives):
	hit_screen.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_screen.visible = false
