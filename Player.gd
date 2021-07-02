extends KinematicBody2D
#Constants
const MOVE_SPEED = 200 #pixels per second
const JUMP_FORCE = 700 #pixels per second
const GRAVITY = 40 #pixels per second
const MAX_FALL_SPEED = 1000 #pixels per second
#importing node references
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
#Define variables
var yVelocity = 0
var facingRight = false

func _physics_process(delta): #Handles all the physics of the character movement
	var moveDirection = 0
	
	#Input controller (Horizontal)
	if Input.is_action_pressed("ui_right"):
		moveDirection += 1
	if Input.is_action_pressed("ui_left"):
		moveDirection -= 1
	move_and_slide(Vector2(moveDirection * MOVE_SPEED,yVelocity),Vector2(0,-1))
	
	#Input controller (Vertical)
	var grounded = is_on_floor()
	yVelocity += GRAVITY
	if grounded and Input.is_action_just_pressed("ui_up"):
		yVelocity = -JUMP_FORCE
	if grounded and yVelocity >= 5: #Resets the fall velocity if the character is touching the ground so that the velociity doesn't accumulate as they walk
		yVelocity = 2
	if yVelocity > MAX_FALL_SPEED: #Limits the vertical velocity to a maximum fall speed
		yVelocity = MAX_FALL_SPEED
		
	#Sprite Flipper
	if facingRight and moveDirection > 0:
		flip()
	if !facingRight and moveDirection < 0:
		flip()
		
	#Animation Handler
	if grounded:
		if moveDirection == 0:
			playAnimation("idle")
		else:
			playAnimation("run")
	else:
		playAnimation("jump")

#Sprite Flipper Function
func flip():
	facingRight = !facingRight
	sprite.flip_h = !sprite.flip_h

func playAnimation(animationName):
	if animationPlayer.is_playing() and animationPlayer.current_animation == animationName:
		return
	animationPlayer.play(animationName)
