extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#SignalBus.navigation_tile_event.connect(_resource_location_ping)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _resource_location_ping():
	SignalBus.resource_location_ping.emit(global_position)

func _on_body_entered(body):
	hide()
	$ResourceHurtbox.set_deferred("disabled", true)
	queue_free()
	SignalBus.resource_collected.emit()
