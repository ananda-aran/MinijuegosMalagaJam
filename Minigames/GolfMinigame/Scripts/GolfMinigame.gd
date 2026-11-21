extends MinigameBase

@export var ball: PackedScene

#@onready var ball = $"ball start/ball"
@onready var arrow = $"ball start/Rotate_Arrow"
@onready var labelstart = $UI/Label
@onready var start_point = $"ball start"

@onready var current_ball #=$"ball start/ball" #DEBUG

var current_player: int =-1
var clockwise: bool = false
var can_shoot: bool = false


signal shot
signal end_game

func _ready() -> void:
	print("ready")
	instantiate_level()
	set_double_physics()
	print(PlayersController.GetCurrentPlayersIds())
	
func OnMinigameStarted() -> void:
	print("Game start")
	game_turns()
	InputController.playerButtonPressed.connect(shoot)
	
#func _input(event: InputEvent) -> void: #DEBUG
	#if event.is_action_pressed("start_button"):
		#shoot(current_player)

func _physics_process(delta: float) -> void:
	rotate_arrow()

func instantiate_level():
	var level = load("res://Minigames/GolfMinigame/prefabs/level_2.tscn").instantiate()
	add_child(level)

func game_turns():
	#await get_tree().create_timer(2).timeout
	for player in PlayersController.GetCurrentPlayersIds():

		labelstart.text=str(player)+ " start"
		labelstart.show()
		
		
		var new_ball = ball.instantiate()
		add_child(new_ball)
		#new_ball.global_position=start_point.global_position
		new_ball.player=player
		new_ball.change_color()
		await get_tree().create_timer(1).timeout
		labelstart.hide()
		

		current_player=player
		current_ball=new_ball
		current_ball.add_to_group("balls")
		arrow.show()
		await get_tree().physics_frame
		can_shoot=true
		await shot
		await current_ball.stopping
	current_player=-1
	game_ended()

func shoot(id):
	print(id)
	if current_player==id:
		print("hit")
		shot.emit()
		current_ball.unfreeze()
		current_ball.apply_central_impulse(calculate_shoot() * 2)
		current_ball.shot=true
		arrow.hide()
		can_shoot=false
	end_game.emit()

func game_ended():
	print("END")
	set_normal_physics()
	get_winner()
		
func rotate_arrow():
	if clockwise==false:
		#arrow.rotation_degrees.y+=1
		arrow.rotate_y(0.015)
	if clockwise==true:
		#arrow.rotation_degrees.y-=1
		arrow.rotate_y(-0.015)
	if arrow.rotation_degrees.y<=-90:
		clockwise=false
	if arrow.rotation_degrees.y>=90:
		clockwise=true
		
func calculate_shoot():
	var direction = Vector2.from_angle(arrow.rotation.y)
	#var direction = arrow.global_transform.basis.z

	print(direction)
	return Vector3(direction.y, 0,direction.x)
	#return direction



func get_winner():
	var lowest_distance=INF
	var current_distance
	var winner
	for ball in get_tree().get_nodes_in_group("balls"):
		var goal = get_tree().get_first_node_in_group("goal")
		current_distance=(ball.global_position-goal.global_position).length()
		if (ball.global_position-goal.global_position).length() <= lowest_distance:
			lowest_distance = current_distance
			winner=ball
			print(lowest_distance)
			print(winner)
	labelstart.show()
	labelstart.text=str(winner.player)+" wins"
	ScoreManager.AddVictoryToPlayer(winner.player)
	await end_game
	TransitionToNextMinigame()
	
	
func set_double_physics():
	Engine.time_scale = 2.0
	Engine.physics_ticks_per_second = 120 
func set_normal_physics():
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = 60
	
