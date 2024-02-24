extends Node2D

var gameScene = preload("res://scenes/game.tscn")
var save_path = "user://money.save"

func _ready():
	$"button contrainer/continue game button".disabled = true

func _on_start_game_button_pressed():
	Global.money = 20
	get_tree().change_scene_to_packed(gameScene)

func _on_quit_game_button_pressed():
	get_tree().quit()

func _on_save_data_pressed():
	save()
	print("saved data. money =" + str(Global.money))

func _on_load_data_pressed():
	load_data()
	$"button contrainer/continue game button".text = "Continue ($" + str(Global.money) + ")"
	print("loaded data. money =" + str(Global.money))
	if Global.money == 0:
		$"button contrainer/continue game button".disabled = true
	else:
		$"button contrainer/continue game button".disabled = false

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.money)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Global.money = file.get_var(Global.money)
	else:
		print("No data saved.")
		Global.money = 0


func _on_continue_game_button_pressed():
	get_tree().change_scene_to_packed(gameScene)
