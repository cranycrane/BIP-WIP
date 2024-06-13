extends CharacterBody3D

@export var lives = 2
@export var max_speed = 1.0

@export var player_path : NodePath
@export var attack_speed = 2.0
@export var got_hit_time = 0.5
@export var animation_player : AnimationPlayer
@export var enemy_knockback = 5

@onready var nav_agent = $NavigationAgent3D
@onready var hit_timer = $HitTimer  # Reference to the Timer node
@onready var got_hit_timer = $GotHitTimer
@export var knockback: float

var original_position: Vector3
var player: CharacterBody3D = null

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var detected_player = false
var can_hit_player = false
var original_color = null
var material = null

#unused
#@onready var enemy_area = get_parent() #there may be ebtter ways to access parent
#var follow_distance: float = 12.0
#var return_distance: float = 10.0

#possible to simplify
func _ready():
	player = get_node(player_path)
	original_position = global_transform.origin
	hit_timer.wait_time = attack_speed
	add_to_group("enemy")

func _process(delta):
	if lives <= 0:
		# todo play death sound
		queue_free()
		
	if can_hit_player and hit_timer.is_stopped() and got_hit_timer.is_stopped():
		_hit_finished()
		
	#var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	var player_position = player.global_position
	var enemy_position = global_position
	
	if got_hit_timer.is_stopped():
		# Calculate the direction to the player, ignoring the Y axis
		direction = Vector3.ZERO
		if detected_player: #Follow player
			direction = (player_position - enemy_position).normalized()
			direction.y = 0  #implicit if on same height base
			direction = direction.normalized()
		else:	#Return to original position with small threshold
			if enemy_position.distance_to(original_position) > 0.2:
				direction = (original_position - enemy_position).normalized()
				direction.y = 0
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
	var dir = global_position.direction_to(player.global_position)
	print("DOING DAMAGE " + str(self))
	player.hit(dir)
	hit_timer.start()

func hit(dir, attack_damage, knockback):
	print(name + " got hit")
	#$Ghol_Ground1_2/Armature/Skeleton3D/Ghool_P.material.albedo_color = Color(1.0, 0.0, 0.0)
	got_hit_timer.start(got_hit_time)
	direction += Vector3(1,0,1) * enemy_knockback * dir
	lives -= attack_damage

func _on_color_timer_timeout():
	pass


	


func _on_enemy_hit_box_body_entered(body):
	if body.name == "Player":
		print("PLAYER ENTERED HITBOX")
		can_hit_player = true

func _on_enemy_hit_box_body_exited(body):
	if body.name == "Player":
		print("player EXITED hitbox")
		can_hit_player = false
