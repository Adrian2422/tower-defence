extends Area2D

@export var speed: float = 500.0
@export var steer_force: float = 50.0

var explosion: PackedScene = preload("res://Scenes/SupportScenes/explosion.tscn")

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO
var target: PathFollow2D = null

signal missile_hit(target: PathFollow2D)

func start(_transform: Transform2D, _target: Node2D) -> void:
	global_transform = _transform
	rotation += randf_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target
	$AnimationPlayer.play("Flare")

func seek() -> Vector2:
	var steer: Vector2 = Vector2.ZERO
	if is_instance_valid(target):
		var desired: Vector2 = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta: float) -> void:
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func _on_body_entered(body: Node) -> void:
	if is_instance_valid(target) and body == target.get_node("CharacterBody2D"):
		missile_hit.emit(target)
		explode()

func _on_lifetime_timeout() -> void:
	explode()

func explode() -> void:
	#$Particles2D.emitting = false
	for i in get_tree().get_nodes_in_group("sprites"):
		i.visible = false
	set_physics_process(false)

	var new_explosion: Node = explosion.instantiate()
	$Fuse.add_child(new_explosion)
	await new_explosion.animation_finished
	queue_free()
