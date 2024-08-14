extends AnimatedSprite2D


func _ready():
	play("Impact")


func _on_animation_finished():
	queue_free()
