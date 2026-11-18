extends RigidBody3D

@export var player: int = 0

@onready var mesh = $MeshInstance3D

var shot: bool = false
var sped_up: bool = false

func _ready() -> void:
	freeze=true

func change_color():
	if player == 0:
		mesh.material_override = preload("res://Minigames/GolfMinigame/materials/player_0.tres")
	if player == 1:
		mesh.material_override = preload("res://Minigames/GolfMinigame/materials/player_1.tres")
	if player == 2:
		mesh.material_override = preload("res://Minigames/GolfMinigame/materials/player_2.tres")
	if player == 3:
		mesh.material_override = preload("res://Minigames/GolfMinigame/materials/player_3.tres")

func unfreeze():
	freeze=false
	
func _physics_process(delta: float) -> void:
	if shot==true:
		if linear_velocity.length() >= 0.1:
			sped_up=true
		if linear_velocity.length() <= 0.07 and sped_up==true:
			linear_damp=15
