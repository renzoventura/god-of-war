extends "res://scenes/enemy/Enemy.gd"

var player = null
const SPEED = 200





func attack_feature():
	chase_player()

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	if player_direction.x > player_direction.y:
		player_direction.y = 0
	else:
		player_direction.x =0
	move_and_slide(SPEED * player_direction.normalized())

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	return player_direction + Vector2(0,-2)
