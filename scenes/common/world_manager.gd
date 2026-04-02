extends Node

# Old base game 12 level enum
#enum {
	#STAGE_SELECT, SADNESS_AREA_A, SADNESS_AREA_B, SADNESS_AREA_C, 
	#ANGER_AREA_A, ANGER_AREA_B, ANGER_AREA_C, 
	#FEAR_AREA_A, FEAR_AREA_B, FEAR_AREA_C, 
	#JOY_AREA_A, JOY_AREA_B, JOY_AREA_C, 
	#}

# New Experiment 9 level enum
enum {
	STAGE_SELECT, SADNESS_AREA_A, SADNESS_AREA_B, 
	ANGER_AREA_A, ANGER_AREA_B, ANGER_AREA_C, 
	FEAR_AREA_A, FEAR_AREA_B, 
	JOY_AREA_A, JOY_AREA_B
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

# ordered!
# TODO: Should this be entered in via file? Would be easy
@export var neutral_prompts = [
	"Tutorial",
	"When was the last time you walked for more than an hour? \nDescribe where you went and what you saw.",
	"If you could invent a new flavor of ice cream, what would it be? \nWhy?",
	"If you had to move from California, where would you go, and what would you miss about California? \nWhy would you miss this?",
	"What is the best TV show you've seen in the last month? \nTell your partner about it. ",
	"What was your impression of UC Berkeley the first time you came here? \nWhy?",
	"What foreign country would you most like to visit? \nWhat attracts you to this place?",
	"Do you think left-handed people are more creative than right-handed people? \nWhy?",
	"Do you prefer digital watches and clocks or the kind with hands? \nWhy?",
]

@export var increasing_closeness_prompts = [
	"Tutorial",
	"When was the last time you walked for more than an hour? \nDescribe where you went and what you saw.",
	"What would constitute a “perfect” day for you?",
	"When did you last sing to yourself? To someone else? \nDescribe the situation.",
	"If a crystal ball could tell you the truth about yourself, your life, the future, \nor anything else, what would you want to know? Why?",
	"Is there something that you’ve dreamed of doing for a long time? \nWhy haven’t you done it?",
	"If you knew that in one year you would die suddenly, would you change \nanything about the way you are now living? Why?",
	"What is your most terrible memory? \nWhy so?",
	"Of all the people in your family, whose death would you find most disturbing? \nWhy?",
]

@export var decreasing_closeness_prompts = [
	"Tutorial",
	"When was the last time you walked for more than an hour? \nDescribe where you went and what you saw.",
	"Of all the people in your family, whose death would you find most disturbing? \nWhy?",
	"What is your most terrible memory? \nWhy so?",
	"If you knew that in one year you would die suddenly, would you change \nanything about the way you are now living? Why?",
	"Is there something that you’ve dreamed of doing for a long time? \nWhy haven’t you done it?",
	"If a crystal ball could tell you the truth about yourself, your life, the future, \nor anything else, what would you want to know? Why?",
	"When did you last sing to yourself? To someone else? \nDescribe the situation.",
	"What would constitute a “perfect” day for you?",
]

# NOTE: General Prompts
@export var world_initalization_data = null

# TODO: Modify areas down to 8!!

func set_world_initalization_data(prompts):
	self.world_initalization_data = {
		self.JOY_AREA_A : {
		self.AtlasID : 1,
		self.Prompt : prompts[7],
	},
	self.JOY_AREA_B : {
		self.AtlasID : 1,
		self.Prompt : prompts[8],
	},
	#self.JOY_AREA_C : {
		#self.AtlasID : 1,
		#self.Prompt : prompts[11],
	#},
	self.SADNESS_AREA_A : {
		self.AtlasID : 2,
		self.Prompt : prompts[0],
	},
	self.SADNESS_AREA_B : {
		self.AtlasID : 2,
		self.Prompt : prompts[1],
	},
	#self.SADNESS_AREA_C : {
		#self.AtlasID : 2,
		#self.Prompt : prompts[2],
	#},
	self.FEAR_AREA_A : {
		self.AtlasID : 3,
		self.Prompt : prompts[5],
	},
	self.FEAR_AREA_B : {
		self.AtlasID : 3,
		self.Prompt : prompts[6],
	},
	#self.FEAR_AREA_C : {
		#self.AtlasID : 3,
		#self.Prompt : prompts[8],
	#},
	self.ANGER_AREA_A : {
		self.AtlasID : 4,
		self.Prompt : prompts[2],
	},
	self.ANGER_AREA_B : {
		self.AtlasID : 4,
		self.Prompt : prompts[3],
	},
	self.ANGER_AREA_C : {
		self.AtlasID : 4,
		self.Prompt : prompts[4],
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

# NOTE: Quints 08/29/25
#@export var world_initalization_data = {
	#self.JOY_AREA_A : {
		#self.AtlasID : 1,
		#self.Prompt : "Write what you like about someone at this party but don't mention their name.\nLet's see if we can figure it out.",
	#},
	#self.JOY_AREA_B : {
		#self.AtlasID : 1,
		#self.Prompt : "Write about the joy of the journey you have had with The Beans, and what it means to be here now!",
	#},
	#self.JOY_AREA_C : {
		#self.AtlasID : 1,
		#self.Prompt : "",
	#},
	#self.SADNESS_AREA_A : {
		#self.AtlasID : 2,
		#self.Prompt : "",
	#},
	#self.SADNESS_AREA_B : {
		#self.AtlasID : 2,
		#self.Prompt : "Share about the last piece of media that made you sad.\nMaybe someone can relate.",
	#},
	#self.SADNESS_AREA_C : {
		#self.AtlasID : 2,
		#self.Prompt : "What is something you miss about the college years?\nMaybe someone shares similar feelings.",
	#},
	#self.FEAR_AREA_A : {
		#self.AtlasID : 3,
		#self.Prompt : "What are you fearful about as we begin to become Unc's?\nMaybe someone shares similar feelings.",
	#},
	#self.FEAR_AREA_B : {
		#self.AtlasID : 3,
		#self.Prompt : "Share about the last piece of media that made you scared?\nSome people love a good scary story.",
	#},
	#self.FEAR_AREA_C : {
		#self.AtlasID : 3,
		#self.Prompt : "Write a spooky scary story about The Beans.\nYour creativity might just fuel someone elses!",
	#},
	#self.ANGER_AREA_A : {
		#self.AtlasID : 4,
		#self.Prompt : "What angers you about the clankers right now?\n11001110000000001111001101...",
	#},
	#self.ANGER_AREA_B : {
		#self.AtlasID : 4,
		#self.Prompt : "Share about the last adulting thing that made you angry.\nJust let it out.",
	#},
	#self.ANGER_AREA_C : {
		#self.AtlasID : 4,
		#self.Prompt : "Write a story about how anger can turn into fear.\nYour creativity might just fuel someone elses!",
	#},
#}

@export var world_dynamic_data = {
	"experiment_condition": null,
	"world_data": {
		"areas_completed" = 1,
		"player_count" = 1,
		"play_history" = ["? ? ? - 612 keystrokes pressed"],
	},
	self.JOY_AREA_A : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.JOY_AREA_B : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	#self.JOY_AREA_C : {
		#"current_area_passage" = null,
		#"current_area_passage_author" = null,
		#"passage_title" = null,
		#"area_comments" = [],
	#},
	self.SADNESS_AREA_A : {
		#"current_area_passage" = "Hey! Thanks for finding your way to this here brain! I stumbled upon this world and I found out that a bunch of Neurons are in dire need of some help! We need to help them get to the end of the brain joureny though making connections between the different brain areas: Sadness, Anger, Fear, and Joy. The best way to do that... is putting our thoughts to words! Write out new passages or type out the stories of your friends! From 123's to abc's and all sorts of (){}@#& there is plenty to work with. Well I got to gather up other people to help finish the journey, thanks for helping out already!!!",
		"first_response" = null,
		"current_area_passage" = "Welcome to BrainType. Through the game, you will be interacting with a partner who is also playing in the same session. You will be asked to respond to a prompt (in around 50-75 words). After you respond, your partner will be able to see what you wrote and will be asked to type the response. Next, they will respond to the same prompt. You will then be asked to type out their response before moving to the next round. While they are responding, we ask that you not touch your monitor or keyboard as you wait for your turn. To begin, we will start with a practice round.",
		"current_area_passage_author" = "? ? ?",
		"prompt" = "Tutorial Passage",
		"passage_title" = "Tutorial Passage",
		"area_comments" = [],
	},
	self.SADNESS_AREA_B : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	#self.SADNESS_AREA_C : {
		#"current_area_passage" = null,
		#"current_area_passage_author" = null,
		#"passage_title" = null,
		#"area_comments" = [],
	#},
	self.FEAR_AREA_A : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.FEAR_AREA_B : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	#self.FEAR_AREA_C : {
		#"current_area_passage" = null,
		#"current_area_passage_author" = null,
		#"passage_title" = null,
		#"area_comments" = [],
	#},
	self.ANGER_AREA_A : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA_B : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
		"passage_title" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA_C : {
		"first_response" = null,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"prompt" = null,
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
	
func update_experiment_condition(condition: int):
	var condition_name = Global.ExperimentalConditions.find_key(condition)
	self.world_dynamic_data["experiment_condition"] = condition_name
	
func save_area_first_passage(area_enum: int):
	var first_passage = self.world_dynamic_data[area_enum]["current_area_passage"]
	var first_passage_author = self.world_dynamic_data[area_enum]["current_area_passage_author"]
	var first_passage_title = self.world_dynamic_data[area_enum]["passage_title"]
	
	self.world_dynamic_data[area_enum]["first_response"] = {"first_response_passage" : first_passage, 
		"first_response_author": first_passage_author,
		"first_passage_title": first_passage_title}
	
	self.world_dynamic_data[area_enum]["current_area_passage"] = null
	self.world_dynamic_data[area_enum]["current_area_passage_author"] = null
	self.world_dynamic_data[area_enum]["passage_title"] = null
	
func area_experiment_condition_completed(area_enum: int):
	if self.world_dynamic_data[area_enum]["first_response"] != null and self.world_dynamic_data[area_enum]["current_area_passage"] != null:
		return true
	else:
		return false
	
func get_dynamic_data(area_enum : int):
	return self.world_dynamic_data[area_enum]

func write_world_data(area_enum : int, key : String, value):
	if typeof(self.world_dynamic_data[area_enum][key]) == TYPE_ARRAY:
		self.world_dynamic_data[area_enum][key].append(value)
	else:
		self.world_dynamic_data[area_enum][key] = value
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
