extends MinigameBase

@onready var ball = $"ball start/ball"
@onready var arrow = $"ball start/Rotate_Arrow"

var clockwise: bool = false

func _ready() -> void:
	InputController.playerButtonPressed.connect(shoot)

func _process(delta: float) -> void:
	rotate_arrow()

func shoot(id):
	print(id)
	if id ==0:
		print("hit")
		ball.apply_impulse(calculate_shoot() * 1.5)
		arrow.hide()
		
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
