extends Node3D

@onready var hit_screen = $HitScreen

func _ready():
	hit_screen.visible = false
	
func _process(double):
	print("FPS %d" % Engine.get_frames_per_second())

func _on_player_player_hit(current_lives):
	hit_screen.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_screen.visible = false

