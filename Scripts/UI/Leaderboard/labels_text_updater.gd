extends Node

@onready var well_done_rich_text_label: RichTextLabel = $"../VBoxContainer/WellDoneRichTextLabel"
@onready var total_score_label: Label = $"../VBoxContainer/TotalScoreLabel"

@onready var max_seq_rich_text_label: RichTextLabel = $"../VBoxContainer/StatsContainer/MaxSeqRichTextLabel"
@onready var avg_reac_rich_text_label: RichTextLabel = $"../VBoxContainer/StatsContainer/AvgReacRichTextLabel"



func update_labels():
	update_score_label()
	update_well_done_rtlabel()
	update_max_seq_label()
	update_avg_reaction_label()

func update_score_label():
	total_score_label.text = str(GameManager.pontuacao_atual)

func update_well_done_rtlabel():
	var first_name = str(GameManager.first_name).to_upper()
	well_done_rich_text_label.text = "MANDOU BEM, %s !" % [first_name] 

func update_max_seq_label():
	max_seq_rich_text_label.text = "SEQUÊNCIA MÁXIMA : [color=#93FC56]%d [/color]" % [GameManager.max_sequence]

func update_avg_reaction_label():
	if GameManager.average_reaction_time <= 0.0:
		avg_reac_rich_text_label.text = "TEMPO MÉDIO DE REAÇÃO : —"
		return
	avg_reac_rich_text_label.text = "TEMPO MÉDIO DE REAÇÃO : [color=#93FC56] %.2fs por bataki[/color]" % [GameManager.average_reaction_time]
