extends "res://src/code/player_globals.gd"

func _enter(host : KinematicBody2D):
	host.animation.play("Walk")
	_get_input_and_apply_move(host)

func _exit(host : KinematicBody2D):
	host.animation.stop()

func _get_input_and_apply_move(host):
	var move_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = walk_speed*move_direction
	velocity = host.move_and_slide(velocity, floor_normal)
	
	host.animation.flip_h = velocity.x < 0

func update(host : KinematicBody2D, delta):
	if velocity.x == 0:
		return 'Idle'
	
	if Input.is_action_just_pressed("ui_up"):
		return 'Jump'

	if velocity.y > 0:
		return 'Fall'
	
	_apply_gravity(delta)
	_get_input_and_apply_move(host)