extends Node2D

var rng = RandomNumberGenerator.new()
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

func _on_btn_deal_pressed():
	if bet < 1:
		print("Cannot deal, bet below 1.")
		return
	_disable_buttons()
	print("Starting game process.")
