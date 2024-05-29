extends CharacterBody3D

var push_speed = 5.0
var push_direction = Vector3.ZERO
var is_being_pushed = false

func _ready():
	$Area3D.connect("body_entered", _on_body_entered)
	$Area3D.connect("body_exited", _on_body_exited)

func _physics_process(delta):
	if is_being_pushed:
		print("Pushing block in direction: ", push_direction)
		var collision = move_and_collide(push_direction * push_speed * delta)
		if collision:
			print("Collision detected, stopping block.")
			is_being_pushed = false
			push_direction = Vector3.ZERO

func _on_body_entered(body):
	if body.name == "Player":
		var player_velocity = body.get_velocity()  # Get player's velocity
		if player_velocity.length() > 0:
			push_direction = player_velocity.normalized()
			is_being_pushed = true
			print("Player entered block area with velocity: ", player_velocity)
			print("Block is being pushed in direction: ", push_direction)
		else:
			# If player velocity is zero, use player's facing direction
			push_direction = get_player_direction(body)
			if push_direction != Vector3.ZERO:
				is_being_pushed = true
				print("Player entered block area with zero velocity. Using facing direction: ", push_direction)
				print("Block is being pushed in direction: ", push_direction)

func _on_body_exited(body):
	if body.name == "Player":
		is_being_pushed = false
		push_direction = Vector3.ZERO
		print("Player exited block area, stopping block.")

func get_player_direction(player):
	# Replace with logic to determine player's facing direction
	# For example, if player has an orientation or direction property, use it here
	# This is a placeholder logic, assuming player has a `facing_direction` property
	if player.has_method("get_facing_direction"):
		return player.get_facing_direction()
	else:
		return Vector3.ZERO
