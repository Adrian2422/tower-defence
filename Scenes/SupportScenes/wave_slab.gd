extends PathFollow2D

var wave_data: Wave

signal start_wave(wave: Wave)


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if progress_ratio == 1.0:
		start_wave.emit(wave_data)
		queue_free()
	move(delta)


func move(delta: float) -> void:
	set_progress(get_progress() + 10 * delta)
