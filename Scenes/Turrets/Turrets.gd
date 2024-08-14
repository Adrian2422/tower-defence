extends Node2D

var type: String
var category: String
var is_rotation_locked: bool = false
var enemy_array: Array[PathFollow2D] = []
var built: bool = false
var enemy: PathFollow2D
var is_ready: bool = true


func _ready():
	if built:
		$Range/CollisionShape2D.get_shape().radius = 0.5 * GameData.tower_data[type]["range"]


# Called every physics frame. Used for heavy calculations e.g. physics. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		if not $AnimationPlayer.is_playing():
			turn()
		if is_ready:
			fire()
	else:
		enemy = null


func turn():
	if is_rotation_locked:
		pass
	else :
		$Turret.look_at(enemy.position)


func select_enemy():
	var enemy_progress_array: Array[float] = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)

	var max_offset = enemy_progress_array.max()
	var enemy_index: int = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func fire():
	is_ready = false
	if category == "projectile":
		fire_gun()
	elif category == "missile":
		fire_missile()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout
	is_ready = true


func fire_gun():
	$AnimationPlayer.play("Fire")


func fire_missile():
	pass


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
