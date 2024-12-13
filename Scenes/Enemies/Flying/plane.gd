class_name PlaneBase extends Enemy

@onready var shadow = $ShadowMarker

func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
