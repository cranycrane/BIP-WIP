extends Area3D

signal player_entered(enemy)
signal player_exited(enemy)

@export var enemy_path : NodePath
var enemy

func _ready():
	enemy = get_node(enemy_path)

func _on_body_entered(body):
	if body.name == "Player":
		print("PLAYER ENTERED")
		enemy.on_player_entered(enemy)

func _on_body_exited(body):
	if body.name == "Player" and get_node_or_null(enemy_path):
		enemy.on_player_exited(enemy)
