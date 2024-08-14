extends Node2D

var map_node 

var build_mode: bool  = false
var build_valid: bool = false
var build_tile
var build_location
var build_type 

var current_wave: int = 0
var enemies_in_wave: int = 0

func _ready():
	map_node = get_node("Map1") 	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))

func _process(_delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

#
# Waves 
#

func start_next_wave():
	var wave_data: Array[Variant] = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data() -> Array[Variant]:
	var wave_data: Array[Variant] = [["blue_tank", 0.7], ["blue_tank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy: Node = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
#
# Building 
#

func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	
	build_type = tower_type + "T1"
	build_mode = true 
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "039c0870")
		build_valid = true 
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "cf000070")
		build_valid = false

func cancel_build_mode():
	build_mode = false 
	build_valid = false 
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		var new_tower: Node = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 5, Vector2i(1, -0))
