extends Node

export (PackedScene) var Mob  # choose what mob scene to use
var score 


func _ready():
	randomize()  # make sure every random is unique


func new_game():
	# new game is connected to HUD start game button
	score = 0
	$Player.start($StartPosition.position)  # call the players start function and pass the start position
	$StartTimer.start()  # start the start timer
	$HUD.show_message("Get Ready")
	$HUD.update_score(score)
	$Music.play()


func game_over():
	$ScoreTimer.stop()  # stop the score timer
	$MobTimer.stop()  # stop generating new mobs
	$HUD.game_over()
	$DeathSound.play()
	$Music.stop()

func _on_MobTimer_timeout():
	# generate new mobs on a random location along the mob spawn location node
	$MobPath/MobSpawnLocation.set_offset(randi())  # generate a random location along the path
	var mob = Mob.instance()  # generate new mob instance
	add_child(mob)  # add it as a child to main
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/4, PI/4)  # give the mob a random , on top of it's spawned rotation
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))  # set the velocity of the object with random speed and attach direction

func _on_StartTimer_timeout():
	# start timer will start the other two timers, so when it timesout (after 2sec):
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1  # increment the score counter when the score timer timesout
	$HUD.update_score(score)
	


