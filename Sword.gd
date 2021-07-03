extends KinematicBody2D

onready var player = get_node("res://Player.tscn")
var target = null
var move = Vector2.ZERO
var MOVE_SPEED = 3


func _on_Area2D_body_entered(body):
	target = null

func _on_Area2D_body_exited(body):
	if body != self:
		target = body

func _physics_process(delta):
	if target!=null:
		move = position.direction_to(target.position) *  MOVE_SPEED
	else:
		move = Vector2.ZERO
	
#	move = move.normalized()
	move_and_collide(move)
