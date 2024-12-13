class_name Turret extends Node2D

var is_rotation_locked: bool = false
var target_array: Array[Enemy] = []
var built: bool = false
var current_target: PathFollow2D
var is_ready: bool = true

var type: TurretData.TurretTypes
var tier: int
var projectile_type: TurretData.ProjectileTypes
var damage: int
var rate_of_fire: int
var range: int
var cost: int


func _ready() -> void:
	if built:
		$Range/CollisionShape2D.get_shape().radius = 0.5 * range


# Called every physics frame. Used for heavy calculations e.g. physics. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if target_array.size() != 0 and built:
		select_target()
		if not has_node("AnimationPlayer"): 
			turn()
		elif not $AnimationPlayer.is_playing():
			turn()
		if is_ready:
			fire()
	else:
		# turret zapomina przeciwnika jesli wyjedzie jako ostatni z range
		current_target = null


func turn() -> void:
	if is_rotation_locked:
		pass
	else :
		$Turret.look_at(current_target.position)


func select_target() -> void:
	var target_progress_array: Array[float] = []
	for i in target_array:
		target_progress_array.append(i.progress)

	var max_offset = target_progress_array.max()
	var target_index: int = target_progress_array.find(max_offset)
	current_target = target_array[target_index]


func fire() -> void:
	push_error("Function is not implemented")


func _on_range_body_entered(body: Node2D) -> void:
	target_array.append(body.get_parent())


func _on_range_body_exited(body: Node2D) -> void:
	target_array.erase(body.get_parent())
