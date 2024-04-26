extends Node3D

signal coin_collected 


func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("coin_collected")
		queue_free()
