extends CharacterBody3D

@export var lives = 2
@export var max_speed = 1.0

@export var player_path : NodePath
@export var attack_speed = 2.0
@export var hit_color_time = 0.5

@onready var nav_agent = $NavigationAgent3D
@onready var hit_timer = $HitTimer  # Reference to the Timer node
@onready var color_timer = $ColorTimer
@onready var animation_player = $Ghol_Ground1_2/AnimationPlayer


var original_position: Vector3
var player: CharacterBody3D = null

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var detected_player = false

#unused
#@onready var enemy_area = get_parent() #there may be ebtter ways to access parent
#var follow_distance: float = 12.0
#var return_distance: float = 10.0


#possible to simplify
func _ready():
	player = get_node(player_path)
	original_position = global_transform.origin
	hit_timer.wait_time = attack_speed
	hit_timer.timeout.connect(_hit_finished)
	add_to_group("enemy")

func _process(delta):
	
	if lives <= 0:
		# todo play death sound
		queue_free()
			
	direction = Vector3.ZERO
	
	
	if not hit_timer.is_stopped() and color_timer.is_stopped():
		return

	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	var player_position = player.global_position
	var enemy_position = global_position

	# Calculate the direction to the player, ignoring the Y axis
	
	if detected_player: #Follow player
		direction = (player_position - enemy_position)
		#direction.y = 0  #implicit if on same height base
		direction = direction.normalized()
		print(direction)
	else:	#Return to original position with small threshold
		if enemy_position.distance_to(original_position) > 0.1:
			direction = (original_position - enemy_position)
		else:
			direction = Vector3.ZERO
	
	velocity.x = direction.x * max_speed
	velocity.z = direction.z * max_speed
	
	if direction != Vector3.ZERO:
		look_at(global_transform.origin + direction, Vector3.UP)
		animation_player.play("ArmatureAction") 
	else:
		animation_player.stop()
		
	move_and_slide()
	
func on_player_entered(enemy): #detect if only the specified enemy within the signal works
	print("player_entered enemy area")
	if enemy == self:
		detected_player = true
		
func on_player_exited(enemy):
	print("player_exited enemy area")
	if enemy == self:
		detected_player = false
	
	
func _hit_finished():
	if hit_timer.is_stopped():
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		hit_timer.start()

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		hit_timer.start()
		_hit_finished()
		

func _on_enemy_hit_box_body_exited(body):
	pass # Replace with function body.

func hit(dir, attack_damage, knockback):
	print(name + " got hit")
	#$Ghol_Ground1_2/Armature/Skeleton3D/Ghool_P.material.albedo_color = Color(1.0, 0.0, 0.0)
	color_timer.start(hit_color_time)
	if velocity != Vector3.ZERO:
		velocity += Vector3(1,0,1) * dir * knockback
	else:
		velocity += Vector3(1,0,1) * knockback * dir
	lives -= attack_damage

func _on_color_timer_timeout():
	#$Ghol_Ground1_2/Armature/Skeleton3D/Ghool_P.material.albedo_color = Color(1.0, 1.0, 1.0) 
	pass
	
#unused now
func follow_player():
	nav_agent.set_target_position(player.global_transform.origin)

func return_to_position():
	nav_agent.set_target_position(original_position)
	
func move_along_path(delta: float):
	# Navigation
	# nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * max_speed


func _on_ghoul_area_3d_player_entered():
	pass # Replace with function body.



func _on_enemy_hit_box_body_entered(body):
	pass # Replace with function body.
