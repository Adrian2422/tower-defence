class_name RedTank extends Tank

func _init() -> void:
	hp = 35
	speed = 170
	base_dmg = 25
	value = 50

func impact() -> void:
	randomize()
	var x_pos = randi() % 31
	var y_pos = randi() % 21
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)
