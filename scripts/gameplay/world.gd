extends Node3D

@onready var hit_rect = $Control/HitRect

func _ready():
	hit_rect.visible = false

func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false
