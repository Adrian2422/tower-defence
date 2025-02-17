class_name GunT2 extends Turret


func _init() -> void:
	damage = 25
	rate_of_fire = 0.5
	range = 350
	type = TurretData.TurretTypes.GUN
	tier = 2
	category = TurretData.ProjectileTypes.BULLET


func fire() -> void:
	is_ready = false
	$AnimationPlayer.play("Fire")
	
	enemy.on_hit(damage)
	await get_tree().create_timer(rate_of_fire).timeout
	is_ready = true
