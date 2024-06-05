extends CharacterBody3D

const SPEED = 2.0
const SHOOT_RANGE = 10.0  # Range for shooting projectiles

@export var follow_distance: float = 12.0
@export var return_distance: float = 10.0
@export var player_path : NodePath
@export var projectile_scene: PackedScene
@export var shoot_interval: float = 2.0  # Time between shots
@export var projectile_speed: float = 10.0

@onready var nav_agent = $NavigationAgent3D
@onready var shoot_timer = $ShootTimer  # Reference to the Timer node
@onready var projectile_spawn = $ProjectileSpawn  # Position3D for spawning projectiles

var player = null
var original_position: Vector3

func _ready():
	player = get_node(player_path)
	original_position = global_transform.origin
	shoot_timer.wait_time = shoot_interval
	shoot_timer.one_shot = false  # Make sure the timer repeats
	shoot_timer.start()
	add_to_group("enemy")

func _process(delta):		
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	velocity = Vector3.ZERO
	
	if distance_to_player < follow_distance:
		follow_player()
	elif distance_to_player > return_distance:
		return_to_position()
	
	# which way is enemy looking at player
	# uncomment when enemy model ready
	# look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# @todo animation running etc
	
	move_along_path(delta)
	move_and_slide()

func _target_in_range(range):
	return global_position.distance_to(player.global_position) < range
	
func follow_player():
	nav_agent.set_target_position(player.global_transform.origin)

func return_to_position():
	nav_agent.set_target_position(original_position)
	
func move_along_path(delta: float):
	# Navigation
	# nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	


func _shoot_at_player():
	var projectile_instance = projectile_scene.instantiate()
	var spawn_position = projectile_spawn.global_transform.origin
	projectile_instance.global_transform.origin = spawn_position
	projectile_instance.direction = global_position.direction_to(player.global_position)
	projectile_instance.speed = projectile_speed
	get_parent().add_child(projectile_instance)


func _on_shoot_timer_timeout():
	if _target_in_range(SHOOT_RANGE):
		_shoot_at_player()
