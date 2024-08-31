extends PathFollow2D

var wave_data: Wave
var marked: bool = false

signal start_wave(wave: Wave)


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if progress_ratio == 1.0:
		if marked:
			Globals.wave_slab_speed = 10
			marked = false
		start_wave.emit(wave_data)
		queue_free()
	move(delta)


func move(delta: float) -> void:
	set_progress(get_progress() + Globals.wave_slab_speed * delta)


func _on_button_pressed() -> void:
	marked = true
	Globals.wave_slab_speed = 100
