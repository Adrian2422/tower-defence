class_name MissileT1 extends Turret

var next_launch: int = 1

func _init() -> void:
	damage = 100
	rate_of_fire = 3
	range = 550
	type = TurretData.TurretTypes.MISSILE
	tier = 1
	category = TurretData.ProjectileTypes.MISSILE


func fire() -> void:
	is_ready = false
	reload()
	var new_rocket: Node = load("res://Scenes/Projectiles/Missile.tscn").instantiate()
	add_child(new_rocket)
	var transform: Transform2D = Transform2D($Turret.global_rotation, $Turret.global_position)
	new_rocket.start(transform, current_target)
	next_launch = 2 if next_launch == 1 else 1
	new_rocket.missile_hit.connect(on_missile_hit)
	await get_tree().create_timer(rate_of_fire).timeout
	is_ready = true

func on_missile_hit(target: PathFollow2D) -> void:
	target.on_hit(damage)

func reload() -> void:
	match next_launch:
		1:
			$Turret/Slot1/Missile1.visible = false
			await get_tree().create_timer(2).timeout
			$Turret/Slot1/Missile1.visible = true
		2:
			$Turret/Slot2/Missile2.visible = false
			await get_tree().create_timer(2).timeout
			$Turret/Slot2/Missile2.visible = true
