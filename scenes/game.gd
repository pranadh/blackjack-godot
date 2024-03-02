extends Node2D

var bet = 0

func _ready():
	print(Global.money)
	$conBets/lblMoneyValue.text = "$" + str(Global.money)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - #
#       Betting / Money Knowledge       #
# - - - - - - - - - - - - - - - - - - - #

func _update_bet(amount: int):
	if amount < 0: # Check if player removing from bet.
		if bet + amount < 0: # 0 + (-1) < 0, hence stop.
			print("Bet cannot go below $0.")
			return
		else:
			bet += amount
			$conBets/lblCurrentBet.text = "$" + str(bet)
			Global.money -= amount
			$conBets/lblMoneyValue.text = "$" + str(Global.money)
	else: # Check if player adding to bet.
		if Global.money - amount < 0: # 0 - 1 < 0, hence stop.
			print("Not enough funds to place bet.")
			return
		else:
			Global.money -= amount
			$conBets/lblMoneyValue.text = "$" + str(Global.money)
			bet += amount
			$conBets/lblCurrentBet.text = "$" + str(bet)

func _update_ui():
	$conBets/lblCurrentBet.text = "$" + str(bet)
	$conBets/lblMoneyValue.text = "$" + str(Global.money)
	var player_score = calculate_hand_value(player_hand)
	var dealer_score = calculate_hand_value(dealer_hand)
	$lblDealerCard.text = "Dealer: " + str(dealer_score)
	$lblPlayerCard.text = "Player: " + str(player_score)

func _on_btn_1_pressed():
	_update_bet(1)

func _on_btn_5_pressed():
	_update_bet(5)

func _on_btn_10_pressed():
	_update_bet(10)

func _on_btn_50_pressed():
	_update_bet(50)

func _on_btn_minus_1_pressed():
	_update_bet(-1)

func _on_btn_minus_10_pressed():
	_update_bet(-10)

func _on_btn_minus_50_pressed():
	_update_bet(-50)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - #
#            Game Knowledge             #
# - - - - - - - - - - - - - - - - - - - #

func _disable_buttons():
	$conBets/btn1.disabled = true
	$conBets/btn5.disabled = true
	$conBets/btn10.disabled = true
	$conBets/btn50.disabled = true
	$conBets/btnMinus1.disabled = true
	$conBets/btnMinus10.disabled = true
	$conBets/btnMinus50.disabled = true

func _enable_buttons():
	$conBets/btn1.disabled = false
	$conBets/btn5.disabled = false
	$conBets/btn10.disabled = false
	$conBets/btn50.disabled = false
	$conBets/btnMinus1.disabled = false
	$conBets/btnMinus10.disabled = false
	$conBets/btnMinus50.disabled = false

# A representation of a single card
class Card:
	var suit: String
	var value: String
	var points: int

	func _init(_suit: String, _value: String, _points: int):
		suit = _suit
		value = _value
		points = _points

# Generates a deck of 52 cards
func create_deck():
	var suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
	var values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
	var deck = []

	for suit in suits:
		for i in range(len(values)):
			var points = min(10, i + 2) # Assign points 2-10 for numbered cards, 10 for face cards
			if values[i] in ["J", "Q", "K"]:
				points = 10
			elif values[i] == "A":
				points = 11 # Ace can be 1 or 11, but we'll start with 11
			deck.append(Card.new(suit, values[i], points))
	return deck

# Shuffle the deck
func shuffle_deck(deck):
	var rng = RandomNumberGenerator.new()
	for i in range(deck.size() - 1, 0, -1):
		var r = rng.randi() % (i + 1)
		var temp = deck[i]
		deck[i] = deck[r]
		deck[r] = temp

var deck = []
var player_hand = []
var dealer_hand = []

# Deals a card to a hand
func deal_card(hand):
	if deck.size() == 0:
		deck = create_deck()
		shuffle_deck(deck)
	hand.append(deck.pop_back())

# Initially provides 2 hands to dealer and player
func initial_deal():
	deck = create_deck()
	shuffle_deck(deck)
	player_hand.clear()
	dealer_hand.clear()
	deal_card(player_hand)
	deal_card(dealer_hand)
	deal_card(player_hand)
	deal_card(dealer_hand)
	_update_ui()

# Reset game after bust or win
func reset_game():
	if Global.money == 0:
		$Notifications.play("notification_no_money")
		return
	else:
		_enable_buttons()
		$btnDeal.show()
		$btnHit.hide()
		$btnStand.hide()
		$conBets/AnimationPlayer.play("move_to_right")

# Calculate's hand value
func calculate_hand_value(hand):
	var total = 0
	var aces = 0

	for card in hand:
		total += card.points
		if card.value == "A":
			aces += 1
	while total > 21 and aces > 0:
		total -= 10 # Adjusting Ace from 11 to 1
		aces -= 1

	return total

# Hit and stand functions
func hit(hand):
	deal_card(hand)
	_update_ui()
	if calculate_hand_value(hand) > 21:
		$Notifications.play("notification_player_bust")
		bet = 0
		_update_ui()
		reset_game()
		$btnDeal.hide()
		return "Bust"
	print("Continue")
	return "Continue"

func stand(player_hand, dealer_hand):
	var player_score = calculate_hand_value(player_hand)
	var dealer_score = calculate_hand_value(dealer_hand)
	print(player_score)
	print(dealer_score)

	while dealer_score < 17:
		deal_card(dealer_hand)
		dealer_score = calculate_hand_value(dealer_hand)

	if dealer_score > 21 or player_score > dealer_score:
		print("Player Wins")
		$Notifications.play("notification_player_win")
		Global.money += bet * 2
		bet = 0
		_update_ui()
		return "Player Wins"
	elif dealer_score > player_score:
		print("Dealer Wins")
		$Notifications.play("notification_dealer_win")
		bet = 0
		_update_ui()
		return "Dealer Wins"
	else:
		print("Tie")
		Global.money += bet
		$Notifications.play("notification_tie")
		bet = 0
		_update_ui()
		return "Tie"

# Button functions
func _on_btn_hit_pressed():
	hit(player_hand)
	var player_score = calculate_hand_value(player_hand)
	print(player_score)

func _on_btn_stand_pressed():
	stand(player_hand, dealer_hand)
	reset_game()

func _on_btn_deal_pressed():
	if bet < 1:
		print("Cannot deal, bet below 1.")
		$Notifications.play("notification_bet_value")
		return
	_disable_buttons()
	print("Starting game process.")
	initial_deal()
	$conBets/AnimationPlayer.play("move_to_left")
	$btnDeal.hide()
	$btnHit.show()
	$btnStand.show()


func _on_notifications_animation_finished(anim_name):
	if anim_name == "notification_player_bust":
		$btnDeal.show()
		return
	if anim_name == "notification_no_money":
		get_tree().change_scene_to_file("res://scenes/table.tscn")
		return
