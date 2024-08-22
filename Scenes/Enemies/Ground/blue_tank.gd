class_name BlueTank extends Tank

func _init() -> void:
	hp = 50
	speed = 150
	base_dmg = 21


func impact() -> void:
	randomize()
	var x_pos = randi() % 31
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)


func destroy() -> void:
	var new_explosion = explosion.instantiate()
	destroy_area.add_child(new_explosion)
