extends Node2D

export (PackedScene) var enemy_scn
onready var alien_timer = Timer.new()
onready var last_cause_death : String

func _ready():
	alien_timer.set_wait_time(2)
	add_child(alien_timer)
	alien_timer.connect("timeout", self, "gen_aliens")


func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().quit()


func game_over(cause:String):
	alien_timer.stop()
	
	$Bella.game_over()
	
	$Music.stop()
	
	if cause == "fall":
		$HUD.show_game_over("Oh no! \nHas caído!")
	elif cause == "hit" and last_cause_death != "hit":
		$HUD.show_game_over("Te han \nAbducido!")
	
	last_cause_death = cause

func new_game():
	$Music.play()
	
	$Bella.start(Vector2(50, 100))
	$Bella.show()
	
	alien_timer.start()


func gen_aliens():
	var alien = enemy_scn.instance()
	
	alien.offset = $Bella.position
	
	add_child(alien)
	alien.connect("hit", self, "game_over", ["hit"])
	$HUD.connect("start_game", alien, "free_aliens")
	
	alien_timer.start()