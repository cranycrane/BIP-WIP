extends Node

@export var initial_scene: PackedScene = null

var current_scene: Node = null

func load_initial_scene() -> void:
	if initial_scene:
		current_scene = initial_scene.instantiate()
		add_child(current_scene)
	else:
		print("Error: initial_scene is not set")

func load_new_scene(scene_path: String) -> void:
	if current_scene:
		remove_current_scene()
	var new_scene = load_scene(scene_path)
	if new_scene:
		current_scene = new_scene
		add_child(current_scene)

func remove_current_scene() -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null

func reload_current_scene() -> void:
	if current_scene:
		var scene_path = current_scene.filename
		remove_current_scene()
		load_new_scene(scene_path)

func load_scene(scene_path: String) -> Node:
	var scene_resource = ResourceLoader.load(scene_path)
	if scene_resource:
		return scene_resource.instantiate()
	else:
		print("Error: Could not load scene from path:", scene_path)
		return null

func _ready() -> void:
	load_initial_scene()
