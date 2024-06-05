extends CharacterBody3D

@export var speed = 4.0
@export var player_path : NodePath
@export var lives = 1

@export var attack_speed = 2.0
@export var follow_distance: float = 12.0
@export var return_distance: float = 10.0
@export var hit_color_time = 0.5
@onready var nav_agent = $NavigationAgent3D
@onready var hit_timer = $HitTimer  # Reference to the Timer node
@onready var color_timer = $ColorTimer

var original_position: Vector3
var player = null

func _ready():
	player = get_node(player_path)
	original_position = global_transform.origin
	hit_timer.wait_time = attack_speed
	add_to_group("enemy")

func _process(delta):
	if lives <= 0:
		# todo play death sound
		queue_free()
	
	if not hit_timer.is_stopped() and color_timer.is_stopped():
		return
		
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	#velocity = Vector3.ZERO
	
	if distance_to_player < follow_distance:
		follow_player()
	elif distance_to_player > return_distance:
		return_to_position()
	
	# which way is enemy looking at player
	# uncomment when enemy model ready
	# look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# @todo animation running etc
	if color_timer.is_stopped():
		move_along_path(delta)
	move_and_slide()

func follow_player():
	nav_agent.set_target_position(player.global_transform.origin)

func return_to_position():
	nav_agent.set_target_position(original_position)
	
func move_along_path(delta: float):
	# Navigation
	# nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
func _hit_finished():
	if hit_timer.is_stopped():
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		hit_timer.start()

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		_hit_finished()
		
func hit(dir, attack_damage, knockback):
	print(name + " got hit")
	$CSGCylinder3D.material.albedo_color = Color(1.0, 0.0, 0.0)
	color_timer.start(hit_color_time)
	if velocity != Vector3.ZERO:
		velocity += Vector3(1,0,1) * dir * knockback
	else:
		velocity += Vector3(1,0,1) * knockback * dir
	lives -= attack_damage


func _on_color_timer_timeout():
	$CSGCylinder3D.material.albedo_color = Color(1.0, 1.0, 1.0) 
