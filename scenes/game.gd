extends Node2D

@onready var transition = $Transition
var rng = RandomNumberGenerator.new()
var dealer_value: int = rng.randi_range(1, 11)
var player_value: int = rng.randi_range(1, 21)

func _ready():
	$lblDealerHand.text = str(dealer_value)
	$lblPlayerHand.text = str(player_value)
	print(Global.money)

func _on_btn_hit_pressed():
	player_value = player_value + rng.randi_range(1,10)
	$lblPlayerHand.text = str(player_value)
	print("hit button pressed")
	if player_value > 21:
		print("flopped")
		$lblWinner.text = "bust, dealer win"
		$lblWinner.show()
		$btnRestart.show()
		$VSeparator/btnHit.hide()
		$VSeparator/btnStand.hide()
	elif player_value == 21:
		print("player wins")
		$lblWinner.show()
		$btnRestart.show()
		$VSeparator/btnHit.hide()
		$VSeparator/btnStand.hide()

func _on_btn_stand_pressed():
	print("player stand")
	while dealer_value < 15:
		dealer_value = dealer_value + rng.randi_range(1,10)
		$lblDealerHand.text = str(dealer_value)
	if dealer_value > 21:
		print("player win")
		$lblWinner.show()
		$btnRestart.show()
		$VSeparator/btnHit.hide()
		$VSeparator/btnStand.hide()
	elif dealer_value == player_value:
		print("tie")
		$lblWinner.text = "tie"
		$lblWinner.show()
		$btnRestart.show()
		$VSeparator/btnHit.hide()
		$VSeparator/btnStand.hide()
	elif dealer_value > 15:
		if player_value < dealer_value:
			print("dealer win")
			$lblWinner.text = ("dealer win")
			$lblWinner.show()
			$btnRestart.show()
			$VSeparator/btnHit.hide()
			$VSeparator/btnStand.hide()
		else:
			print("player win")
			$lblWinner.show()
			$btnRestart.show()
			$VSeparator/btnHit.hide()
			$VSeparator/btnStand.hide()
	elif dealer_value == 15:
		if player_value < 15:
			print("dealer win")
			$lblWinner.text = ("dealer win")
			$lblWinner.show()
			$btnRestart.show()
			$VSeparator/btnHit.hide()
			$VSeparator/btnStand.hide()
		else:
			print("player win")
			$lblWinner.show()
			$btnRestart.show()
			$VSeparator/btnHit.hide()
			$VSeparator/btnStand.hide()
	elif dealer_value < 15:
		dealer_value = dealer_value + rng.randi_range(1,10)
		$lblDealerHand.text = str(dealer_value)
	return

func _on_btn_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://scenes/table.tscn")
