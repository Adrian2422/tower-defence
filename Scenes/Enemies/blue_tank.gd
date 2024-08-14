extends PathFollow2D


var hp = 50
var speed = 150

@onready var health_bar = $Healthbar
@onready var impact_area = $Impact
var projectile_impact = preload("res://Scenes/SupportScenes/projectile_impact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)


func _physics_process(delta):
	move(delta)


func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(30, 30)


func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()


func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)


func on_destroy():
	$CharacterBody2D.queue_free()
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
