extends CanvasLayer

func set_tower_preview(tower_type, mouse_position):
	var drag_tower: Node = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.is_rotation_locked = true
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff")
	
	var range_texture = Sprite2D.new()
	range_texture.set_name("RangeIndicator")
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.set_position(mouse_position)
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").set_position(new_position)
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/RangeIndicator").modulate = Color(color)
