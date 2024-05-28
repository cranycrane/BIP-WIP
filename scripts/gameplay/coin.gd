extends Node3D

@export var rotation_speed: float = 1.0

signal coin_collected 

func _process(delta):
	rotate_y(delta * rotation_speed)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("coin_collected")
		$CoinSound.play()
		visible = false
		$CoinSound.finished.connect(_on_coin_sound_finished)

func _on_coin_sound_finished():
	queue_free()
