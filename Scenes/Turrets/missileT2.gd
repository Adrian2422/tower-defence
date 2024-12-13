class_name MissileT2 extends Turret


func _init() -> void:
	damage = 150
	rate_of_fire = 3
	range = 650
	type = TurretData.TurretTypes.MISSILE
	tier = 2
	projectile_type = TurretData.ProjectileTypes.MISSILE
	cost = 150
