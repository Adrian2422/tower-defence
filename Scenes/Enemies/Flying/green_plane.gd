class_name GreenPlane extends PlaneBase

func _ready() -> void:
	super._ready()
	hp = 35
	speed = 170
	base_dmg = 15


func impact() -> void:
	randomize()
	var axis = randi() % 2
	var x_pos: int
	var y_pos: int
	if axis == 0:
		x_pos = randi_range(-25, 25)
		y_pos = randi_range(-3, 3)
	if axis == 1:
		x_pos = randi_range(-4, 4)
		y_pos = randi_range(-29, 29)
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)
