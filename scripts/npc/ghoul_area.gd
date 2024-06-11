extends Area3D

signal player_entered(enemy)
signal player_exited(enemy)

@onready var enemy = $GhoulEnemy

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_entered", $GhoulEnemy) #emit signal onyl for particular enemy

func _on_body_exited(body):
	if body.name == "Player":
		emit_signal("player_exited", $GhoulEnemy) #emit signal onyl for particular enemy
