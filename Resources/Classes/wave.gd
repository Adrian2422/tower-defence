class_name Wave

@export var enemy_type: String
@export var interval: float
@export var amount: int


func _init(_enemy_type, _interval, _amount):
	enemy_type = _enemy_type
	interval = _interval
	amount = _amount
