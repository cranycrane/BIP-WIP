extends Node3D

#func _process(delta):
	# Assuming the player rotates on Y-axis using mouse or keyboard input
	#rotation.y = owner.rotation.y  # Sync with player's rotation
@export var cameraFrom:  Camera3D
@export var cameraTo:  Camera3D
@onready var camera3D: Camera3D = $Camera

#@onready var tween: Tween = $Tween 
#not working

var transitioning: bool = false
func transition_camera(from: Camera3D, to: Camera3D, duration: float = 1.0 ) -> void:
	print("tween")
	if transitioning: return
	# Copy the parameters of the first camera
	camera3D.fov = from.fov
	camera3D.cull_mask= from.cull_mask
	# Move our transition camera to the first camera position
	camera3D.global_transform = from.global_transform
	# Make our transition camera current
	camera3D.enabled = true
	transitioning = true
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera3D, "global_transform", to.global_transform, duration).from(camera3D.global_transform)
	tween.tween_property(camera3D, "fov", to.fov, duration).from(camera3D.fov)

	# Wait for the tween to complete
	await tween.finished
	# Make the second camera current
	to.enabled = true
	transitioning = false
	
func cameraTransitionAnimation() -> void:
	print("transition")
	transition_camera(cameraFrom,cameraTo, 3.0)
