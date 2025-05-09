extends Node

enum {
	STAGE_SELECT, SADNESS_AREA_A, SADNESS_AREA_B, SADNESS_AREA_C, 
	ANGER_AREA_A, ANGER_AREA_B, ANGER_AREA_C, 
	FEAR_AREA_A, FEAR_AREA_B, FEAR_AREA_C, 
	JOY_AREA_A, JOY_AREA_B, JOY_AREA_C, 
	}

# Initalization data key constants
const AtlasID = "overworld_chunk_atlas_id"
const Prompt = "prompt"

# Dynamic data key constants
const AreasCompleted = "areas_completed"
const PlayerCount = "player_count"
const PlayHistory = "play_history"
const AreaHealth = "area_health"
const CurrAreaPassage = "current_area_passage"
const CurrAreaPassageAuthor = "current_area_passage_author"
const CurrAreaPassageTitle = "passage_title"
const AreaComments = "area_comments"

@export var current_player_area = self.STAGE_SELECT

# NOTE: General Prompts
@export var world_initalization_data = {
	self.JOY_AREA_A : {
		self.AtlasID : 1,
		self.Prompt : "What were you happy about last year?\nIt is always good to share the positives!",
	},
	self.JOY_AREA_B : {
		self.AtlasID : 1,
		self.Prompt : "Write about the joy of the journey, and what it means to reach the destination!",
	},
	self.JOY_AREA_C : {
		self.AtlasID : 1,
		self.Prompt : "It's the end....\nWrite whatever you want!",
	},
	self.SADNESS_AREA_A : {
		self.AtlasID : 2,
		self.Prompt : "Write a short story about sadness.\nYour creativity just might fuel someone elses!",
	},
	self.SADNESS_AREA_B : {
		self.AtlasID : 2,
		self.Prompt : "Share about the last movie that made you sad.\nMaybe someone can relate.",
	},
	self.SADNESS_AREA_C : {
		self.AtlasID : 2,
		self.Prompt : "What made you melancholy about last year?\nMaybe someone shares similar feelings.",
	},
	self.FEAR_AREA_A : {
		self.AtlasID : 3,
		self.Prompt : "What are you fearful about?\nMaybe someone shares similar feelings.",
	},
	self.FEAR_AREA_B : {
		self.AtlasID : 3,
		self.Prompt : "Share about the last movie that made you fearful?\nSome people love a good scary movie.",
	},
	self.FEAR_AREA_C : {
		self.AtlasID : 3,
		self.Prompt : "Write a story about how fear and joy interact.\nYour creativity might just fuel someone elses!",
	},
	self.ANGER_AREA_A : {
		self.AtlasID : 4,
		self.Prompt : "What confuses you about anger?\nWe always feel like, we have it figured it out sometimes...",
	},
	self.ANGER_AREA_B : {
		self.AtlasID : 4,
		self.Prompt : "Share about the last movie that made you angry.\nI wonder if anyone else watched it?",
	},
	self.ANGER_AREA_C : {
		self.AtlasID : 4,
		self.Prompt : "Write a story about how anger can turn into fear.\nYour creativity might just fuel someone elses!",
	},
}

# NOTE: Caliburst Demo!
#@export var world_initalization_data = {
	#self.JOY_AREA_A : {
		#self.AtlasID : 1,
		#self.Prompt : "What is the best part of Xrd?\nIt is always good to share the positives!",
	#},
	#self.JOY_AREA_B : {
		#self.AtlasID : 1,
		#self.Prompt : "Write about the joy of the journey, and what it means to reach the destination!",
	#},
	#self.JOY_AREA_C : {
		#self.AtlasID : 1,
		#self.Prompt : "",
	#},
	#self.SADNESS_AREA_A : {
		#self.AtlasID : 2,
		#self.Prompt : "What makes you sad about your character?\nWill other players call you crazy?",
	#},
	#self.SADNESS_AREA_B : {
		#self.AtlasID : 2,
		#self.Prompt : "What makes you sad about another character?\nMaybe someone can relate.",
	#},
	#self.SADNESS_AREA_C : {
		#self.AtlasID : 2,
		#self.Prompt : "Write a poem about sadness, anger, and Xrd.\nYour creativity just might fuel someone elses!",
	#},
	#self.FEAR_AREA_A : {
		#self.AtlasID : 3,
		#self.Prompt : "Which character is the scariest to run into in bracket and why?\nMaybe someone shares similar feelings.",
	#},
	#self.FEAR_AREA_B : {
		#self.AtlasID : 3,
		#self.Prompt : "What is the spookiest button in Xrd? Spoooooooky.",
	#},
	#self.FEAR_AREA_C : {
		#self.AtlasID : 3,
		#self.Prompt : "Write a poem about fear, joy, and Xrd.\nYour creativity might just fuel someone elses!",
	#},
	#self.ANGER_AREA_A : {
		#self.AtlasID : 4,
		#self.Prompt : "What makes you angry about your own character?\nJust might say what someone wants to hear...",
	#},
	#self.ANGER_AREA_B : {
		#self.AtlasID : 4,
		#self.Prompt : "Which character do you hate the most?\n Let it out, we are here for you.",
	#},
	#self.ANGER_AREA_C : {
		#self.AtlasID : 4,
		#self.Prompt : "Write a poem about anger, fear, and Xrd.\nYour creativity might just fuel someone elses!",
	#},
#}

# NOTE: I-school Mario Kart Night Demo!
#@export var world_initalization_data = {
	#self.JOY_AREA_A : {
		#self.AtlasID : 1,
		#self.Prompt : "What are you happy about coming to the end of the semester?\nIt is always good to share the positives!",
	#},
	#self.JOY_AREA_B : {
		#self.AtlasID : 1,
		#self.Prompt : "Write about the joy of the journey, and what it means to reach the destination!",
	#},
	#self.JOY_AREA_C : {
		#self.AtlasID : 1,
		#self.Prompt : "",
	#},
	#self.SADNESS_AREA_A : {
		#self.AtlasID : 2,
		#self.Prompt : "Write a short story about sadness.\nYour creativity just might fuel someone elses!",
	#},
	#self.SADNESS_AREA_B : {
		#self.AtlasID : 2,
		#self.Prompt : "Share about the last I-school class that made you sad.\nMaybe someone can relate.",
	#},
	#self.SADNESS_AREA_C : {
		#self.AtlasID : 2,
		#self.Prompt : "Which proffessor / lecturer will you miss the most?\nMaybe someone shares similar feelings.",
	#},
	#self.FEAR_AREA_A : {
		#self.AtlasID : 3,
		#self.Prompt : "What are you fearful about coming to the end of this semester?\nMaybe someone shares similar feelings.",
	#},
	#self.FEAR_AREA_B : {
		#self.AtlasID : 3,
		#self.Prompt : "Share about the last I-school class that made you scared?\nSome people love a good scary story.",
	#},
	#self.FEAR_AREA_C : {
		#self.AtlasID : 3,
		#self.Prompt : "Write a spooky scary story about South Hall.\nYour creativity might just fuel someone elses!",
	#},
	#self.ANGER_AREA_A : {
		#self.AtlasID : 4,
		#self.Prompt : "What angers you about the job search right now?\nWe always feel like, we have it figured it out sometimes...",
	#},
	#self.ANGER_AREA_B : {
		#self.AtlasID : 4,
		#self.Prompt : "Share about the last I-school class that made you angry.\nI wonder if anyone else was in it?",
	#},
	#self.ANGER_AREA_C : {
		#self.AtlasID : 4,
		#self.Prompt : "Write a story about how anger can turn into fear.\nYour creativity might just fuel someone elses!",
	#},
#}

@export var world_dynamic_data = {
	"world_data": {
		"areas_completed" = 1,
		"player_count" = 1,
		"play_history" = ["? ? ? - 612 keystrokes pressed"],
	},
	self.JOY_AREA_A : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.JOY_AREA_B : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.JOY_AREA_C : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.SADNESS_AREA_A : {
		"current_area_passage" = "Hey! Thanks for finding your way to this here brain! I stumbled upon this world and I found out that a bunch of Neurons are in dire need of some help! We need to help them get to the end of the brain joureny though making connections between the different brain areas: Sadness, Anger, Fear, and Joy. The best way to do that... is putting our thoughts to words! Write out new passages or type out the stories of your friends! From 123's to abc's and all sorts of (){}@#& there is plenty to work with. Well I got to gather up other people to help finish the journey, thanks for helping out already!!!",
		"current_area_passage_author" = "? ? ?",
		"passage_title" = "Neurons needs help!!",
		"area_comments" = [],
	},
	self.SADNESS_AREA_B : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.SADNESS_AREA_C : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.FEAR_AREA_A : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.FEAR_AREA_B : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.FEAR_AREA_C : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA_A : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA_B : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA_C : {
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
}

func get_initalization_data(area_enum : int):
	return self.world_initalization_data[area_enum]
	
func get_world_data(key = null):
	if key != null:
		return self.world_dynamic_data["world_data"][key]
	else:
		return self.world_dynamic_data["world_data"]

func update_areas_completed():
	self.world_dynamic_data["world_data"]["areas_completed"] += 1
	
func update_player_count():
	self.world_dynamic_data["world_data"]["player_count"] += 1
	
func update_play_history(play_feed_string : String):
	self.world_dynamic_data["world_data"]["play_history"].append(play_feed_string)
	
func get_dynamic_data(area_enum : int):
	return self.world_dynamic_data[area_enum]

func write_world_data(area_enum : int, key : String, value):
	if typeof(self.world_dynamic_data[area_enum][key]) == TYPE_ARRAY:
		self.world_dynamic_data[area_enum][key].append(value)
	else:
		self.world_dynamic_data[area_enum][key] = value
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
