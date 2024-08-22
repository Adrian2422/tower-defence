class_name Enemy
extends PathFollow2D

signal base_damage(damage: int)
var hp: int       = 1
var speed: int    = 1
var base_dmg: int = 1

@onready var health_bar = $Healthbar
@onready var impact_area = $Impact
@onready var destroy_area = $Destroy

var projectile_impact: PackedScene = preload("res://Scenes/SupportScenes/projectile_impact.tscn")
var explosion: PackedScene = preload("res://Scenes/SupportScenes/explosion.tscn")


func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)


func _physics_process(delta: float) -> void:
	if progress_ratio == 1.0:
		base_damage.emit(base_dmg)
		queue_free()

	move(delta)


func move(delta: float) -> void:
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(30, 30)


func on_hit(damage: int) -> void:
	var initial_hp: int = hp
	impact()
	hp -= damage
	health_bar.value = hp
	if hp < initial_hp:
		$Healthbar.visible = true
	if hp <= 0:
		$Healthbar.visible = false
		on_destroy()


func impact() -> void:
	push_error("Function is not implemented")


func destroy() -> void:
	push_error("Function is not implemented")


func on_destroy() -> void:
	destroy()
	$CharacterBody2D.queue_free()
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
