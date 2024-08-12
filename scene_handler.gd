extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MainMenu/Margin/VBoxContainer/NewGame").connect("pressed", self.on_new_game_pressed)
	get_node("MainMenu/Margin/VBoxContainer/Quit").connect("pressed", self.on_quit_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene: Node = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()
