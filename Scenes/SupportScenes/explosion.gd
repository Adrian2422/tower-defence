extends AnimatedSprite2D


func _ready():
	play("Explode")


func _on_animation_finished():
	queue_free()
