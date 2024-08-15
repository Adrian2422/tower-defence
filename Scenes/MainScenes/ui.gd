extends CanvasLayer

@onready var hp_bar = $HUD/InfoBar/H2/HP

func set_tower_preview(tower_type: String, mouse_position: Vector2) -> void:
	var drag_tower: Node = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.is_rotation_locked = true
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff")
	var range_texture = Sprite2D.new()
	range_texture.set_name("RangeIndicator")
	var scaling = drag_tower.range / 600.0
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
	move_child($TowerPreview, 0)

func update_tower_preview(new_position: Vector2, color: Color) -> void:
	$TowerPreview.set_position(new_position)
	if $TowerPreview/DragTower.modulate != Color(color):
		$TowerPreview/DragTower.modulate = Color(color)
		$TowerPreview/RangeIndicator.modulate = Color(color)

#
# Game Control
#

func _on_pause_play_pressed() -> void:
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true


func _on_fast_forward_pressed() -> void:
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)


func update_health_bar(base_health: int) -> void:
	var hp_bar_tween = hp_bar.create_tween()
	hp_bar_tween.tween_property(hp_bar, "value", base_health, 0.1)
	if base_health >= 60:
		hp_bar.tint_progress = Color("3cc510") # Green
	elif base_health <= 60 and base_health >= 25:
		hp_bar.tint_progress = Color("e1be32") # Orange
	else:
		hp_bar.tint_progress = Color("e11e1e") # Red
