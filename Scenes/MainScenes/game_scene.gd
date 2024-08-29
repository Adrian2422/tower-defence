extends Node2D

signal game_finished()

var map_node: Node2D
var player_health = 100
var player_money = 100

var build_mode: bool  = false
var build_valid: bool = false
var build_tile: Vector2i
var build_location: Vector2
var build_type: String

var current_wave: int = 0
var enemies_in_wave: int = 0

var enemy_scenes: Dictionary = {
	"green_plane": preload("res://Scenes/Enemies/Flying/green_plane.tscn"),
	"blue_tank": preload("res://Scenes/Enemies/Ground/blue_tank.tscn"),
	"red_tank": preload("res://Scenes/Enemies/Ground/red_tank.tscn")
}


#region Lifecycle
func _ready() -> void:
	map_node = get_node("Map1")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))

func _process(_delta: float) -> void:
	if build_mode:
		update_tower_preview()

func _unhandled_input(event) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
#endregion

#region Waves
func start_next_wave() -> void:
	var wave_data: Wave = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)


func retrieve_wave_data() -> Wave:
	current_wave += 1
	var wave_data: Wave = map_node.waves[current_wave]
	enemies_in_wave = wave_data.amount
	return wave_data


func spawn_enemies(wave_data: Wave) -> void:
	for i in range(0, wave_data.amount, 1):
		randomize()
		var path_number: int = randi_range(1,2)
		var new_enemy: Node = enemy_scenes[wave_data.enemy_type].instantiate()
		new_enemy.base_damage.connect(on_base_damage)
		new_enemy.add_money.connect(on_enemy_destroy)
		map_node.get_node("Path" + str(path_number)).add_child(new_enemy, true)
		await get_tree().create_timer(wave_data.interval).timeout


func on_base_damage(damage: int) -> void:
	player_health -= damage
	if player_health <= 0:
		game_finished.emit()
	else:
		$UI.update_health_bar(player_health)


func on_enemy_destroy(value: int) -> void:
	player_money += value
	$UI.update_money(player_money)

#endregion

#region Building
func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	build_type = tower_type.to_lower() + 'T1'
	build_mode = true 
	$UI.set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_tile: Vector2i = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var tile_position: Vector2 = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile) == -1:
		$UI.update_tower_preview(tile_position, "039c0870")
		build_valid = true 
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, "cf000070")
		build_valid = false

func cancel_build_mode() -> void:
	build_mode = false 
	build_valid = false 
	$UI/TowerPreview.free()

func verify_and_build() -> void:
	if build_valid:
		var new_tower: Node = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 5, Vector2i(1, -0))
#endregion
