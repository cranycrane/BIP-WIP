extends Node3D

@export var num_of_coins = 5

@onready var hit_rect = $Control/HitRect

func _ready():
	if hit_rect:
		hit_rect.visible = false
	else:
		print("HitRect node not found!")

func _on_player_player_hit(current_lives):
	if hit_rect:
		hit_rect.visible = true
		await get_tree().create_timer(0.2).timeout
		hit_rect.visible = false
	else:
		print("HitRect node not found!")
