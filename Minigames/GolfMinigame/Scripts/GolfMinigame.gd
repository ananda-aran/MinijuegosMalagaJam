extends MinigameBase

@onready var ball = $"ball start/ball"
@onready var arrow = $"ball start/Rotate_Arrow"
@onready var label = $UI/Label

var current_player: int =-1
var clockwise: bool = false

signal shot

func _ready() -> void:
	print("ready")
	print(PlayersController.GetCurrentPlayersIds())
	
func OnMinigameStarted() -> void:
	print("Game start")
	InputController.playerButtonPressed.connect(shoot)
	game_turns()

func _process(delta: float) -> void:
	rotate_arrow()

func game_turns():
	#await get_tree().create_timer(2).timeout
	for player in PlayersController.GetCurrentPlayersIds():
		print(str(player)+" Start")
		current_player=player
		await shot
	current_player=-1
	game_ended()

func shoot(id):
	print(id)
	if current_player==id:
		print("hit")
		shot.emit()
		ball.apply_impulse(calculate_shoot() * 1.5)
		arrow.hide()

func game_ended():
	print("END")
		
func rotate_arrow():
	if clockwise==false:
		arrow.rotation_degrees.y+=1
	if clockwise==true:
		arrow.rotation_degrees.y-=1
	if arrow.rotation_degrees.y<=-90:
		clockwise=false
	if arrow.rotation_degrees.y>=90:
		clockwise=true
		
func calculate_shoot():
	var direction = Vector2.from_angle(arrow.rotation.y)
	print(direction)
	return Vector3(direction.y, 0,direction.x)



func get_winner():
	pass
