extends Node2D

#var resource_global_positions = []
var world_nodes : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.resource_collected.connect(_set_resources_global_positions)
	
	world_nodes = get_all_children(self)
	
	### World Pre-processing and Data bookkeeping
	
	# Resource locations
	_set_resources_global_positions()

func get_all_children(node):
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

func _set_resources_global_positions():
	Global.world_resources_global_positions = []
	for node in world_nodes:
		if node.name == "Resource":
			if not node.is_queued_for_deletion():
				Global.world_resources_global_positions.append(node.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
