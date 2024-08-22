class_name GunT1 extends Turret


func _init() -> void:
	damage = 20
	rate_of_fire = 1
	range = 350
	type = TurretData.TurretTypes.GUN
	tier = 1
	category = TurretData.ProjectileTypes.BULLET


func fire() -> void:
	is_ready = false
	$AnimationPlayer.play("Fire")
	
	current_target.on_hit(damage)
	await get_tree().create_timer(rate_of_fire).timeout
	is_ready = true
