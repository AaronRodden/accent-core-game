extends Node

# Player Area string constants
enum {STAGE_SELECT, JOY_AREA, SADNESS_AREA, FEAR_AREA, ANGER_AREA}

# Initalization data key constants
const AtlasID = "overworld_chunk_atlas_id"

# Dynamic data key constants
const AreaHealth = "area_health"
const CurrAreaPassage = "current_area_passage"
const CurrAreaPassageAuthor = "current_area_passage_author"
const AreaComments = "area_comments"

@export var current_player_area = self.STAGE_SELECT

@export var world_initalization_data = {
	self.JOY_AREA : {
		self.AtlasID : 1,
	},
	self.SADNESS_AREA : {
		self.AtlasID : 2,
	},
	self.FEAR_AREA : {
		self.AtlasID : 3,
	},
	self.ANGER_AREA : {
		self.AtlasID : 4,
	}
}

@export var world_dynamic_data = {
	self.JOY_AREA : {
		"area_health" = 100,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"area_comments" = [],
	},
	self.SADNESS_AREA : {
		"area_health" = 100,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"area_comments" = [],
	},
	self.FEAR_AREA : {
		"area_health" = 100,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"area_comments" = [],
	},
	self.ANGER_AREA : {
		"area_health" = 100,
		"current_area_passage" = null,
		"current_area_passage_author" = null,
		"area_comments" = [],
	},
}

func get_initalization_data(area_enum : int):
	return self.world_initalization_data[area_enum]
	
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
