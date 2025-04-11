extends Node

# Player Area string constants
#enum {STAGE_SELECT, JOY_AREA, SADNESS_AREA, FEAR_AREA, ANGER_AREA}

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

@export var world_initalization_data = {
	self.JOY_AREA_A : {
		self.AtlasID : 1,
		self.Prompt : "What are you happy about?\nIt is always good to share the positives!",
	},
	self.JOY_AREA_B : {
		self.AtlasID : 1,
		self.Prompt : "Write about the joy of the journey, and what it means to reach the destination!",
	},
	self.JOY_AREA_C : {
		self.AtlasID : 1,
		self.Prompt : "",
	},
	self.SADNESS_AREA_A : {
		self.AtlasID : 2,
		self.Prompt : "What are you sad about?\nMaybe someone shares similar feelings.",
	},
	self.SADNESS_AREA_B : {
		self.AtlasID : 2,
		self.Prompt : "Share a time you were sad.\nMaybe someone can relate.",
	},
	self.SADNESS_AREA_C : {
		self.AtlasID : 2,
		self.Prompt : "Write a poem about how sadness can turn into anger.\nYour creativity just might fuel someone elses!",
	},
	self.FEAR_AREA_A : {
		self.AtlasID : 3,
		self.Prompt : "What are you fearful about?\nMaybe someone shares similar feelings.",
	},
	self.FEAR_AREA_B : {
		self.AtlasID : 3,
		self.Prompt : "Is fear something to be conquered or to be lived with?",
	},
	self.FEAR_AREA_C : {
		self.AtlasID : 3,
		self.Prompt : "Write a poem about how fear and joy interact.\nYour creativity might just fuel someone elses!",
	},
	self.ANGER_AREA_A : {
		self.AtlasID : 4,
		self.Prompt : "What confuses you about anger?\nWe always feel like, we have it figured it out sometimes...",
	},
	self.ANGER_AREA_B : {
		self.AtlasID : 4,
		self.Prompt : "What made you angry this year?",
	},
	self.ANGER_AREA_C : {
		self.AtlasID : 4,
		self.Prompt : "Write a poem about how anger can turn into fear.\nYour creativity might just fuel someone elses!",
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

@export var world_dynamic_data = {
	"world_data": {
		"areas_completed" = 0,
		"player_count" = 0,
		"play_history" = [],
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
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"passage_title" = null,
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
