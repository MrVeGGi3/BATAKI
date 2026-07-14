class_name SQLManipulator
extends Node

const DB_PATH = "user://bataki.db"

const COLUMNS = """
	id         INTEGER PRIMARY KEY AUTOINCREMENT,
	f_name     TEXT    NOT NULL,
	email      TEXT,
	enterprise TEXT,
	score      INTEGER NOT NULL DEFAULT 0,
	max_seq    INTEGER NOT NULL DEFAULT 0,
	avg_time   REAL    NOT NULL DEFAULT 0.0,
	date_time  TEXT    NOT NULL
"""

const EXPECTED_COLUMNS = {
	"id": "INTEGER",
	"f_name": "TEXT",
	"email": "TEXT",
	"enterprise": "TEXT",
	"score": "INTEGER",
	"max_seq": "INTEGER",
	"avg_time": "REAL",
	"date_time": "TEXT",
}

var _db: SQLite


func _ready() -> void:
	_start_database(false)
	

func _start_database(clean : bool):#false para iniciar sem limpar o db atual
	_db = SQLite.new()
	_db.path = DB_PATH
	_db.verbosity_level = SQLite.QUIET

	if not _db.open_db():
		push_error("Falha ao abrir o banco (%s): %s" % [DB_PATH, _db.error_message])
		return
	if not _db.query("CREATE TABLE IF NOT EXISTS game_stats (%s);" % COLUMNS):
		push_error("Falha ao criar a tabela: %s" % _db.error_message)
		return
	if clean:
		clear_all() #Para limpar o database
	else:
		_migrate_schema()

## CREATE TABLE IF NOT EXISTS não toca numa tabela que já existe: um banco criado por uma
## versão antiga do jogo fica preso ao schema antigo, sem as colunas novas. Toda query que
## cita max_seq ou avg_time falha em silêncio ali, e o ranking volta vazio — que é como
## a tela some. Então a tabela é reconstruída sempre que o schema real diverge do esperado.
##
## As linhas sobrevivem: o que existia nos dois schemas é copiado, o que falta nasce
## com o DEFAULT. Partidas antigas ficam com max_seq/avg_time zerados, o que é honesto —
## esses números nunca foram medidos.
func _migrate_schema() -> void:
	var existing := _read_column_types()
	if existing.is_empty():
		return  # tabela ilegível: o push_error já saiu de _read_column_types()
	if existing == EXPECTED_COLUMNS:
		return

	var preserved: Array[String] = []
	for column_name in EXPECTED_COLUMNS:
		if existing.has(column_name):
			preserved.append(column_name)
	var column_list := ", ".join(preserved)

	var steps = [
		"BEGIN TRANSACTION;",
		"DROP TABLE IF EXISTS game_stats_new;",
		"CREATE TABLE game_stats_new (%s);" % COLUMNS,
		"INSERT INTO game_stats_new (%s) SELECT %s FROM game_stats;" % [column_list, column_list],
		"DROP TABLE game_stats;",
		"ALTER TABLE game_stats_new RENAME TO game_stats;",
		"COMMIT;",
	]
	for step in steps:
		if not _db.query(step):
			push_error("Falha ao migrar o schema: %s" % _db.error_message)
			_db.query("ROLLBACK;")
			return

	print("Banco migrado para o schema atual (colunas preservadas: %s)." % column_list)


## Nome -> tipo declarado de cada coluna de game_stats.
func _read_column_types() -> Dictionary:
	if not _db.query("PRAGMA table_info(game_stats);"):
		push_error("Falha ao ler o schema: %s" % _db.error_message)
		return {}

	var types := {}
	for column in _db.query_result:
		types[str(column.get("name"))] = str(column.get("type")).to_upper()
	return types


func _exit_tree() -> void:
	if _db:
		_db.close_db()


## Grava a pontuação do fim de partida. Retorna false se falhar.
func update_database() -> bool:
	var ok = _db.query_with_bindings(
		"INSERT INTO game_stats (f_name, email, enterprise, score, max_seq, avg_time, date_time) VALUES (?, ?, ?, ?, ?, ?, ?);",
		[GameManager.user_name, GameManager.user_email, GameManager.user_enterprise,
		GameManager.pontuacao_atual, GameManager.max_sequence, GameManager.average_reaction_time,
		GameManager.actual_data_hour])

	if not ok:
		push_error("Falha ao salvar score: %s" % _db.error_message)
		return false
	GameManager.current_run_id = _db.last_insert_rowid
	return true


func order_ranking(count: int = 10) -> Array:
	var ok = _db.query_with_bindings(
		"""
		SELECT id, f_name, score, max_seq, avg_time, date_time FROM game_stats
		ORDER BY score DESC,
		         max_seq DESC,
		         CASE WHEN avg_time > 0 THEN avg_time ELSE 1e9 END ASC,
		         date_time ASC
		LIMIT ?;
		""",
		[count])

	if not ok:
		push_error("Ranking falhou: %s" % _db.error_message)
		return []
	return _db.query_result


## Apaga TODAS as partidas gravadas e reinicia a contagem de ids. Não tem volta.
## Pensado para zerar o ranking entre um dia de evento e outro.
##
## Limpar sqlite_sequence junto é o que faz o próximo jogador voltar a ser o id 1;
## sem isso a tabela continuaria contando de onde parou.
func clear_all() -> bool:
	if not _db.query("DELETE FROM game_stats;"):
		push_error("Falha ao limpar o ranking: %s" % _db.error_message)
		return false

	_db.query("DELETE FROM sqlite_sequence WHERE name='game_stats';")
	GameManager.current_run_id = -1
	return true
