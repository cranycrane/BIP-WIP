extends Area3D

@export var direction = 0

signal move_signal(direction)
signal activated

signal deactivated

func _ready():
	body_entered.connect(_on_plate_body_entered)
	body_exited.connect(_on_plate_body_exited)

func _on_plate_body_entered(body):
	if get_overlapping_bodies().size() == 1:
		$MeshInstance3D.position.y -= 0.05
		#todo play sound
		activated.emit()
		move_signal.emit(direction)

func _on_plate_body_exited(_body):
	if not has_overlapping_bodies():
		$MeshInstance3D.position.y += 0.05
		#todo play sound
		deactivated.emit()
