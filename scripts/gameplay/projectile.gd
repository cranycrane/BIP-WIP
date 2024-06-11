extends Area3D

@export var speed: float = 6.0
var direction: Vector3

func _process(delta):
	global_transform.origin += direction * speed * delta

func _on_body_entered(body):
	if body.name == "Player":
		var dir = global_position.direction_to(body.global_position)
		body.hit(dir)
	queue_free()
