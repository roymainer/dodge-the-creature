extends CanvasLayer

signal start_game


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
	
func game_over():
	# game over is called whenever the player dies
	show_message("Game Over!")
	
	# wait for the message timer to end
	yield($MessageTimer, "timeout")  # it stops the execution of game_over function until MessageTimer timesout!
	
	# reset the HUD when game over
	$StartButton.show()
	$MessageLabel.text = "Dodge\nThe Creeps!"
	$MessageLabel.show()
	
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
	
func _on_MessageTimer_timeout():
	# hide the message when the message timer timesout
	$MessageLabel.hide()  


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")  # notify main that the game started