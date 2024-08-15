extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()


func load_main_menu():
	$MainMenu/Margin/VBoxContainer/NewGame.connect("pressed", self.on_new_game_pressed)
	$MainMenu/Margin/VBoxContainer/Quit.connect("pressed", self.on_quit_pressed)


func on_new_game_pressed():
	$MainMenu.queue_free()
	var game_scene: Node = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	game_scene.game_finished.connect(unload_game)
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()


func unload_game():
	$GameScene.queue_free()
	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()
