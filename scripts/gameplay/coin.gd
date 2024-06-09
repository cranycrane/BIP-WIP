extends Node3D

@export var rotation_speed: float = 1.0
var did_collect = false



signal coin_collected 

func _process(delta):
	rotate_y(delta * rotation_speed)

func _on_body_entered(body):
	if body.name == "Player" && !did_collect:
		did_collect = true
		visible = false
		emit_signal("coin_collected")
		$CoinSound.play()
		$CoinSound.finished.connect(_on_coin_sound_finished)
		
		
func _on_coin_sound_finished():
	queue_free()
