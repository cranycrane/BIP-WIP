extends Node3D

func _process(delta):
	# Assuming the player rotates on Y-axis using mouse or keyboard input
	rotation.y = owner.rotation.y  # Sync with player's rotation
