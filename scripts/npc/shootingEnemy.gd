extends Area3D

@export var shoot_interval: float = 2.0  # Time between shots
@export var projectile_speed: float = 1.0

@export var projectile_scene : PackedScene
@onready var shoot_timer = $ShootTimer  # Reference to the Timer node
@onready var projectile_spawn = $ProjectileSpawn  # Position3D for spawning projectiles

var player_node = null
var player_in_area = false

func _ready():
	shoot_timer.wait_time = shoot_interval
	
func _process(delta):
	if player_in_area:
		var target_position = player_node.global_transform.origin
		target_position.y = 0
		$"..".look_at(target_position, Vector3.UP)
		
	if player_in_area and shoot_timer.is_stopped():
		print("SHOOTING")
		_shoot_at_player(player_node.global_position)

func _shoot_at_player(shoot_direction):
	shoot_timer.start()
	var spawn_position = projectile_spawn.global_transform.origin
	var bullet = projectile_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.speed = projectile_speed
	bullet.global_transform.origin = spawn_position
	bullet.direction = player_node.global_position - bullet.global_transform.origin

func _on_body_entered(body):
	if body.name == "Player":
		player_node = body
		player_in_area = true


func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
