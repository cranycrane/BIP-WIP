extends Area3D

signal player_entered(enemy)

@onready var enemy = $GhoulEnemy

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_entered", $GhoulEnemy) #emit signal onyl for particular enemy
