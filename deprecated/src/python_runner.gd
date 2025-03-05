extends Node

# TODO: Is there a better place to have the py files live?
# or is there a better pathing solution?
const PY_PATH = "C:/Users/Aaron/Documents/GodotProjects/accent-core-game/py/"

# TODO: Use threads?
# https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func output_parser(output_array: Array):
	for output in output_array:
		print(output)

func run(script_name: String, arguments: Array):
	var output = []
	var full_path = PY_PATH + script_name
	arguments.insert(0, full_path)
	var exit_code = OS.execute("python", arguments, output)
		
	return output
