extends CharacterBody2D

enum State{
	IDLE,
	CHASE,
	RETURN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 128
@export var attack_damage: int = 10
@export var attack_speed: float = 1.0
@export var hitpoints: int = 180
@export var aggro_range: float = 256.0
@export var attack_range: float = 80.0
@export_category("Related Scenes")
@export var death_packed: PackedScene

var state: State = State.IDLE

@onready var spawn_point: Vector2 = global_position
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	animation_tree.set_active(true)

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	if state == State.ATTACK:
		return
	if distance_to_player() <= attack_range:
		state = State.ATTACK
		attack()
	elif distance_to_player() <= aggro_range:
		state = State.CHASE
		move()
	elif global_position.distance_to(spawn_point) > 32:
		state = State.RETURN
		move()
	elif state != State.IDLE:
		state = State.IDLE
		update_animation()

func distance_to_player() -> float:
	var distance: float
	return distance

func move() -> void:
	pass

func update_animation() -> void:
	pass

func attack() -> void:
	pass

func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	if hitpoints <= 0:
		death()
		
func death() -> void:
	var death_scene: Node2D = death_packed.instantiate()
	death_scene.position = global_position + Vector2(0.0,-32.0)
	%Effects.add_child(death_scene)
	queue_free()
