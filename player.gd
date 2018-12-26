extends Area2D

# declare signals
signal hit

# declare member variables
export (int) var SPEED  # export allow this member to be visible in the inspector so it will be easier to change later
var velocity = Vector2()
var screensize

func _ready():
	# ready function is called whenever the node is added to the scene, init function
	hide()  # hide the player until moving the keys
	print("Player _ready")
	screensize = get_viewport_rect().size
	

func start(pos):
	position = pos  # set the players position
	show()  # show the player
	# monitoring = true  # enable monitoring collisions, monitoring is a saved expression
	$Collision.disabled = false

func _process(delta):
	# process function is called every frame, meaning 60 times per second
	velocity = Vector2()
	
	# close when pressing Escape key
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		# if speed is greater than 0
		$AnimatedSprite.play()
		$Trail.emitting = true
		# make sure the vector length is normalized to 1 even when two direction keys are pressed at once
		velocity = velocity.normalized() * SPEED  # multiply the velocity vector with the speed to move at constant speed
	else:
		# if speed is 0
		$AnimatedSprite.stop()
		$Trail.emitting = false  # stop trail emitting when the player is not moving
	
	position += velocity * delta  # update the player position
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.x != 0:
		# if moving horizontaly
		$AnimatedSprite.animation = "right"  # update animation to horizontal animation
		$AnimatedSprite.flip_v = false  # don't vertically flip the image
		$AnimatedSprite.flip_h = velocity.x < 0  # if moving left, horizontally flip the image
	elif velocity.y != 0:
		# if moving vertically
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = false
		

func _on_player_body_entered(body):
	# whenever a body enter the players area
	hide()  # hide the player
	emit_signal("hit")  # signal that the player died
	# call_deferred("set_monitoring", false)  # we want the player to stop detecting collisions
	$Collision.disabled = true
