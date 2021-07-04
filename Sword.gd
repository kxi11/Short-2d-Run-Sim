extends KinematicBody2D

#var target = null
onready var sprite = $AnimatedSprite
var speed = 300
var distance = 0
const INITIAL_DISTANCE = 700
var move = Vector2.ZERO
const MOVE_SPEED = 3
var direction = null
var moveDirection = 0
var sword_facing_right = true
var attackPoints = 4

onready var target = get_node("/root/world/Player")

func _on_Area2D_body_entered(_body):
	target = null

func _on_Area2D_body_exited(body):
	if body != self :
		target = get_node("/root/world/Player")

func _physics_process(delta):
	if target:
		direction = (target.position - position).normalized()
		move_and_collide(direction * MOVE_SPEED)
	var step = moveDirection * speed * delta
	if moveDirection > 0:
		if distance > step:
			move_and_collide(Vector2(step,0))
		else:
			distance = 0
	elif moveDirection < 0:
		if distance < step:
			move_and_collide(Vector2(step,0))
		else:
			distance = 0
		
	if sword_facing_right and moveDirection < 0:
		flip()
	if !sword_facing_right and moveDirection > 0:
		flip()


func _on_Player_is_attacking(attackStatus):
	if  attackStatus == true and target == null:
		if attackPoints == 4:
			$AttackReset.start()
			if moveDirection > 0:
				distance = INITIAL_DISTANCE
				$AnimatedSprite.play("attack1")
				attackPoints -= 1
			else:
				distance = INITIAL_DISTANCE * moveDirection
				$AnimatedSprite.play("attack1")
				attackPoints -= 1
		elif attackPoints == 3:
			$AttackReset.start()
			if moveDirection > 0:
				distance = INITIAL_DISTANCE
				$AnimatedSprite.play("attack2")
				attackPoints -= 1
			else:
				distance = INITIAL_DISTANCE * moveDirection
				$AnimatedSprite.play("attack2")
				attackPoints -= 1
		elif attackPoints == 2:
			$AttackReset.start()
			if moveDirection > 0:
				distance = INITIAL_DISTANCE
				$AnimatedSprite.play("attack3")
				attackPoints -= 1
			else:
				distance = INITIAL_DISTANCE * moveDirection
				$AnimatedSprite.play("attack3")
				attackPoints -= 1
		elif attackPoints == 1:
			$AttackReset.start()
			if moveDirection > 0:
				distance = INITIAL_DISTANCE
				$AnimatedSprite.play("attack4")
				attackPoints -= 1
			else:
				distance = INITIAL_DISTANCE * moveDirection
				$AnimatedSprite.play("attack4")
				attackPoints -= 1
	else:
		$AnimatedSprite.play("idle")
		distance = 0

func _on_Player_is_facing_right(facing_direction):
	if facing_direction == true:
		moveDirection = 1
	else:
		moveDirection = -1

func flip():
	sword_facing_right = !sword_facing_right
	sprite.flip_h = !sprite.flip_h


func _on_AttackReset_timeout():
	attackPoints = 4


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack1" or $AnimatedSprite.animation == "attack2" or $AnimatedSprite.animation == "attack3":
		$AnimatedSprite.play("idle")
	elif $AnimatedSprite.animation == "attack4":
		$AnimatedSprite.play("idle")
		attackPoints = 4
