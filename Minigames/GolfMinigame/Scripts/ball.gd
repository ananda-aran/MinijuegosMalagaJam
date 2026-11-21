extends RigidBody3D

@export var player: int = 0

@onready var mesh = $MeshInstance3D

var shot: bool = false
var sped_up: bool = false

signal stopping

func _ready() -> void:
	
	freeze=true
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass

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

func frozen():
	freeze=true
	linear_velocity=Vector3.ZERO
	
	
func _physics_process(delta: float) -> void:
	if shot==true:
		if linear_velocity.length() >= 0.1:
			sped_up=true
		if linear_velocity.length() <= 0.09 and sped_up==true:
			linear_damp=15
			stopping.emit()
