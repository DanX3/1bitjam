class_name Caravan extends CharacterBody2D

const WAVE_DEMONS_COUNT = 8
const WAVES_COUNT = 5
var waves_left = WAVES_COUNT
var demonsWaveLeft = 0

@export var speed: int = 1
@export var refugees: int = 10

@onready var counterLabel = $CanvasLayer/HumansCounter
@onready var passengerSprite = $Passengers
@onready var spawnMarker = $SpawnMarker

var closeDemonsCounter = 0
var castleMarkerPos: Vector2
var CASTLE_POSITION := 120

func _ready():
	castleMarkerPos = get_tree().get_first_node_in_group("castle").global_position
	counterLabel.text = str(refugees)
	if refugees > 0:
		passengerSprite.visible = true
	_on_wave_interval_timeout()

func _process(delta):
	if closeDemonsCounter > 0:
		$WalkPlayer.stop()
		return
	$WalkPlayer.play("walk")
	velocity = Vector2.UP * speed
	move_and_slide()
	
	if global_position.y < castleMarkerPos.y - CASTLE_POSITION:
		EventBusInstance.saved_refugees = refugees
		EventBusInstance.emit_signal("castle_reached")
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
	


func take_damage():
	$BlinkPlayer.play("blink")
	$HitPlayer.play_sound()
	refugees -= 1
	counterLabel.text = str(refugees)
	if refugees <= 0:
		passengerSprite.visible = false		
		EventBusInstance.emit_signal("game_over")

func add_refugee():
	refugees += 1
	counterLabel.text = str(refugees)
	passengerSprite.visible = true
	

func _on_enemy_detector_body_entered(body):
	closeDemonsCounter += 1


func _on_enemy_detector_body_exited(body):
	closeDemonsCounter -= 1


func _on_hurt_box_body_entered(body):
	take_damage()


func _on_hurt_box_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	take_damage()



func _on_wave_interval_timeout():
	waves_left -= 1
	if waves_left < 0:
		$Spawner/WaveInterval.stop()
	demonsWaveLeft = WAVE_DEMONS_COUNT
	$Spawner.spawn()
	demonsWaveLeft -= 1
	$Spawner/DemonInterval.start()


func _on_demon_interval_timeout():
	if spawnMarker.global_position.y < castleMarkerPos.y:
		return
	$Spawner.spawn()
	demonsWaveLeft -= 1
	if demonsWaveLeft <= 0:
		$Spawner/WaveInterval.stop()
