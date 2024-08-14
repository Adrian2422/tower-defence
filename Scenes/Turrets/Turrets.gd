extends Node2D

var type: String
var is_rotation_locked: bool = false
var enemy_array: Array[PathFollow2D] = []
var built = false
var enemy


func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]


# Called every physics frame. Used for heavy calculations e.g. physics. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
	else:
		enemy = null


func turn():
	if is_rotation_locked:
		pass
	else :
		get_node("Turret").look_at(enemy.position)


func select_enemy():
	var enemy_progress_array: Array[float] = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)

	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
