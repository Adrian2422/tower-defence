extends Node2D

var is_rotation_locked: bool = false

# Called every physics frame. Used for heavy calculations e.g. physics. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	turn()


func turn():
	if is_rotation_locked:
		pass
	else :
		var enemy_position = get_global_mouse_position()
		get_node("Turret").look_at(enemy_position)


func on_build_mode(is_enabled):
	print("Build mode: ", is_enabled)
