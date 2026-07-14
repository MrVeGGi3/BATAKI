extends Node

@export var stats_blocks : Array[Control] = []
@onready var sql_manipulator: SQLManipulator = $"../SQLManipulator"
const MAX_ENTRIES = 10

enum BlockState {NORMAL = 0, ACTUAL_PLAYER = 1, FIRST_PLACE = 2}

const BLOCK_TEXTURES_BACKGROUND = {
	BlockState.NORMAL: preload("uid://cvecujt8c73u8"),
	BlockState.FIRST_PLACE: preload("uid://cvecujt8c73u8"),
	BlockState.ACTUAL_PLAYER: preload("uid://x0iyo40kijrv")
}

const BLOCK_TEXT_COLORS = {
		BlockState.NORMAL: {
			"PlayerPositionLabel": Color("#C0C2C8"),
			"PlayerNameLabel":     Color("#F5F5F5"),
			"PlayerPointsLabel":   Color("#93FC56"),
		},
		BlockState.FIRST_PLACE: {
			"PlayerPositionLabel": Color("#93FC56"),
			"PlayerNameLabel":     Color("#F5F5F5"),
			"PlayerPointsLabel":   Color("#93FC56"),
		},
		BlockState.ACTUAL_PLAYER: {
			"PlayerPositionLabel": Color("#161616"),
			"PlayerNameLabel":     Color("#161616"),
			"PlayerPointsLabel":   Color("#161616"),
		}
}


func refresh():
	var entries = sql_manipulator.order_ranking(MAX_ENTRIES)
	var player_index = find_current_player_index(entries)
	for i in stats_blocks.size():
		var row : Control = stats_blocks[i]
		if i >= entries.size():
			row.visible = false      
			continue
		
		var entry : Dictionary = entries[i]
		row.visible = true
		row.get_node("PlayerPositionLabel").text = "%d" % (i + 1)
		row.get_node("PlayerNameLabel").text = str(entry.get("f_name", "—"))
		row.get_node("PlayerPointsLabel").text = str(entry.get("score", 0))
		
		var state: BlockState
		if i == player_index:
			state = BlockState.ACTUAL_PLAYER    
		elif i == 0:
			state = BlockState.FIRST_PLACE
		else:
			state = BlockState.NORMAL
		row.get_node("BlockBackTextureRect").texture = BLOCK_TEXTURES_BACKGROUND[state]
		for label_name in BLOCK_TEXT_COLORS[state]:
			row.get_node(label_name).add_theme_color_override("font_color", BLOCK_TEXT_COLORS[state][label_name])
		

func find_current_player_index(entries: Array) -> int:
	for i in entries.size():
		if int(entries[i].get("id", -1)) == GameManager.current_run_id:
			return i
	return -1

func _update_player_name_label(label : Label, player_name : String):
	label.text = player_name
	
func _update_score_label(label : Label, score : int):
	label.text = str(score)
