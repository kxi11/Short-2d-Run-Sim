extends KinematicBody2D

signal is_attacking(attackStatus)
signal is_facing_right(facing_direction)

#Constants
const MOVE_SPEED = 170 #pixels per second
const JUMP_FORCE = 700 #pixels per second
const GRAVITY = 40 #pixels per second
const MAX_FALL_SPEED = 1000 #pixels per second

#importing node references
onready var sprite = $Sprite
#Define variables
var yVelocity = 0
var facingRight = true
var attacking = false

func _physics_process(_delta): #Handles all the physics of the character movement
	var moveDirection = 0
	var grounded = is_on_floor()
	
	if attacking == false:
	#Input controller (Horizontal)
		if Input.is_action_pressed("ui_right"):
			moveDirection += 1
			emit_signal("is_facing_right",facingRight)
		if Input.is_action_pressed("ui_left") :
			moveDirection -= 1
			emit_signal("is_facing_right",facingRight)
		move_and_slide(Vector2(moveDirection * MOVE_SPEED,yVelocity),Vector2(0,-1))
	
	#Input controller (Vertical)
	yVelocity += GRAVITY
	if grounded and Input.is_action_just_pressed("ui_up"):
		yVelocity = -JUMP_FORCE
	if grounded and yVelocity >= 5: #Resets the fall velocity if the character is touching the ground so that the velociity doesn't accumulate as they walk
		yVelocity = 2
	if yVelocity > MAX_FALL_SPEED: #Limits the vertical velocity to a maximum fall speed
		yVelocity = MAX_FALL_SPEED
	
	if grounded and Input.is_action_just_pressed("attack"):
		attacking = true
		emit_signal("is_attacking",attacking)
		moveDirection = 0
		$Sprite.play("attack")
	
	#Sprite Flipper
	if facingRight and moveDirection < 0:
		flip()
	if !facingRight and moveDirection > 0:
		flip()
		
	#Animation Handler
	if grounded and attacking == false:
		if moveDirection == 0:
			$Sprite.play("idle")
		else:
			$Sprite.play("run")
#	else:
#		$Sprite.play("jump")
	elif grounded and attacking == true:
		moveDirection = 0
		$Sprite.play("attack")
	elif !grounded:
		$Sprite.play("jump")

#Sprite Flipper Function
func flip():
	facingRight = !facingRight
	sprite.flip_h = !sprite.flip_h


func _on_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		attacking = false
		emit_signal("is_attacking",attacking)
