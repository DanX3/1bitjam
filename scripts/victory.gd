extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/VBoxContainer/refugees/refugees_counter.text = str(EventBusInstance.saved_refugees)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
