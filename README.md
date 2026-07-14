# BATAKI

Jogo de reação em arcade para **totem vertical de toque**, feito como teste técnico.
O jogador tem 30 segundos para tocar o bataki aceso no grid 3×3 e acumular pontos.
Ao final, sua pontuação é gravada e ele vê sua posição no ranking dos 10 melhores.

---

## Stack

| | |
|---|---|
| **Engine** | Godot **4.7** — linguagem **GDScript** |
| **Renderer** | GL Compatibility (roda em hardware modesto, típico de totem) |
| **Banco de dados** | **SQLite**, via [godot-sqlite](https://github.com/2shady4u/godot-sqlite) v4.7 (GDExtension) |
| **Resolução** | 1080 × 1920 (retrato, formato totem) |
| **Plataforma alvo** | Windows (desktop x86_64) |

---

## Como rodar

### No editor

1. Abra o projeto no Godot 4.7.
2. O addon `godot-sqlite` já está versionado em `addons/godot-sqlite/` — não precisa instalar nada.
3. `F5` para rodar. O banco é criado sozinho na primeira execução.

### O executável

O build de Windows é uma **pasta**, não um arquivo solto: o `BATAKI.exe` precisa da
`libgdsqlite.windows.template_release.x86_64.dll` ao lado dele. GDExtension não é embutida no
`.pck`. Descompacte o zip inteiro e execute o `.exe` de dentro dele.

### Compilando o executável

1. Instale os modelos de exportação da **mesma versão** do editor (`Editor > Gerenciar Modelos de Exportação`).
2. `Projeto > Exportar > Windows Desktop > Exportar Projeto`.
3. Zipe a pasta de saída inteira.

> O projeto é **100% GDScript**. Use o Godot **padrão**, não a variante .NET — não há
> código C# para compilar, e a variante .NET só aumentaria o tamanho do build.

---

## Banco de dados

### Schema

Uma tabela. O schema vive no código (`Scripts/SQLData/sql_manipulator.gd`) e é materializado
por um `CREATE TABLE IF NOT EXISTS` na primeira execução — não há passo de instalação:

```sql
CREATE TABLE IF NOT EXISTS game_stats (
	id         INTEGER PRIMARY KEY AUTOINCREMENT,
	f_name     TEXT    NOT NULL,   -- nome do jogador (obrigatório)
	email      TEXT,               -- opcional
	enterprise TEXT,               -- opcional
	score      INTEGER NOT NULL DEFAULT 0,
	max_seq    INTEGER NOT NULL DEFAULT 0,   -- maior sequência de acertos da partida
	avg_time   REAL    NOT NULL DEFAULT 0.0, -- tempo médio de reação, em segundos
	date_time  TEXT    NOT NULL    -- ISO 8601, ex: 2026-07-13T10:25:14
);
```

`avg_time` é `REAL`, não `INTEGER`: um tempo de reação é fracionário (0,42 s), e arredondá-lo
para o segundo mais próximo jogaria fora justamente a diferença entre um jogador e outro.

### Evolução do schema

`CREATE TABLE IF NOT EXISTS` **não altera uma tabela que já existe**. Um totem que já rodou uma
versão antiga do jogo ficaria preso ao schema velho: as colunas novas nunca seriam criadas, e
toda query que as cita falharia em silêncio — o ranking voltaria vazio e a tela apareceria sem
nenhum bloco. Foi exatamente o que aconteceu quando `max_seq` e `avg_time` entraram.

Por isso o `_ready()` compara o schema real (via `PRAGMA table_info`) com o esperado e, se
divergirem, reconstrói a tabela preservando as linhas: o que existe nos dois schemas é copiado,
o que falta nasce com o `DEFAULT`. Partidas antigas ficam com `max_seq` e `avg_time` zerados —
o que é honesto, já que esses números não foram medidos na época.

### Onde o arquivo fica

Em `user://bataki.db`, que o Godot resolve para o diretório de dados do usuário:

| Sistema | Caminho |
|---|---|
| Windows | `%APPDATA%\Godot\app_userdata\BATAKI\bataki.db` |
| Linux | `~/.local/share/godot/app_userdata/BATAKI/bataki.db` |

Dados de jogador **não** podem morar em `res://`: essa pasta é somente-leitura no build
exportado, e o save falharia na máquina do cliente.

### Consultando fora do jogo

É um SQLite comum — abre no DB Browser for SQLite, no DBeaver ou no terminal:

```bash
sqlite3 bataki.db "SELECT f_name, score, max_seq, avg_time FROM game_stats ORDER BY score DESC LIMIT 10;"

# exportando os leads do evento
sqlite3 -csv bataki.db "SELECT DISTINCT f_name, email, enterprise FROM game_stats;" > leads.csv
```

### Zerando o ranking

Entre um dia de evento e outro, `SQLManipulator.clear_all()` apaga todas as partidas e reinicia
a contagem de ids (limpando `sqlite_sequence` junto — sem isso o próximo jogador entraria como
id 7 em vez de 1). O método existe, mas **ainda não tem gatilho na interface**: hoje só é
chamável por código. A alternativa sem terminal é apagar o `bataki.db`, que o jogo recria
vazio e já com o schema atual na próxima execução.

---

## Arquitetura

### Fluxo de telas

`Home → Formulário → Regras → Contagem → Gameplay → Ranking → Home`

Toda navegação passa por um único autoload, o **`ScreenFlow`** (`Scripts/Globals_Singletons/`).
Nenhum outro script chama `change_scene_to_file`. Além das rotas, ele também é dono da
**política de inatividade por tela** — o que garante que "Jogar de novo" e "Começar" levem
exatamente à mesma tela, e que a Home (destino do idle) não fique se recarregando sozinha.

### Separação entre lógica e interface

As regras do jogo falam em **índices de 0 a 8** e emitem sinais. Elas não conhecem
`TextureButton`, textura, cena nem singleton — e por isso **rodam sem interface nenhuma**,
o que permite testá-las de forma isolada:

```
BatakiGridUI        --bataki_pressed(4)-->  ScoreCounterManager     (a UI avisa a lógica)
BatakiSorter        --bataki_sorted(7)-->   BatakiGridUI.light_up() (a lógica manda acender)
ScoreCounterManager --hit(4) / miss(2)-->   BatakiGridUI            (a lógica pede feedback)
BatakiTimer         --game_over-->          GameplayScreen          (a tela decide para onde ir)
```

O `BatakiGridUI` é a **única** classe que sabe que um bataki é um `TextureButton`.
O `gameplay_screen_ui_manager` é o ponto de encontro: conhece os dois lados e faz a ligação.

### Camadas

```
Scripts/
├── Globals_Singletons/   ScreenFlow · GameManager · InactivityManager · AudioManager
├── Mechanics/            REGRAS: BatakiSorter · ScoreCounterManager · BatakiTimer
├── UI/                   INTERFACE: BatakiGridUI · HUD · leaderboard · formulário
├── Effects/              feedback visual (texturas, tweens, labels, partículas)
├── Audios/               som de acerto, erro e combo
├── SQLData/              SQLManipulator — persistência
└── Leaderboard/          tela de resultado
```

### Partículas

O `ParticleEffectManager` entra pelas costuras que já existiam, sem tocar nas regras do jogo.
As faíscas do acerto precisam de uma **posição**, e quem sabe traduzir um índice em um lugar da
tela é o `BatakiGridUI` — então é ele que chama o manager, do mesmo jeito que já chamava o
`ButtonEffectManager`. Já o burst do combo não pertence a bataki nenhum, então o manager se
inscreve sozinho em `combo_updated`, como o `GameplayAudio` faz.

Dois detalhes que não são óbvios:

- **Os emissores não são filhos dos botões.** Seria o caminho natural, mas o `correct_effect()`
  faz tween de `scale` e o `error_effect()` faz tween de `modulate` — e `CanvasItem` propaga os
  dois para os filhos. As partículas esticariam junto e ficariam vermelhas. Elas moram numa
  `ParticlesLayer` própria (`z_index = 2`: acima dos batakis, abaixo do texto do combo).
- **Um emissor por bataki, pré-instanciado.** Um emissor só, reposicionado a cada acerto,
  cortaria o burst anterior. E como o `BatakiSorter` nunca sorteia o mesmo bataki duas vezes
  seguidas, um mesmo emissor só é reusado dois acertos depois — bem além da vida das faíscas.
  Nada é instanciado durante a partida.

São `CPUParticles2D`, não `GPUParticles2D`: o projeto roda no renderer Compatibility e os
volumes aqui são de dezenas de partículas, não de milhares — o ganho de GPU não apareceria.

---

## Regras do jogo

| Regra | Valor | Onde ajustar |
|---|---|---|
| Duração da partida | 30 s | `BatakiTimer.initial_max_time` |
| Aviso de "reta final" | últimos 5 s | `BatakiTimer.warn_time` |
| Pontos por acerto | 10 | `ScoreCounterManager.score_to_add` |
| Acertos para subir o combo | 5 | `ScoreCounterManager.hits_for_combo` |
| Teto do multiplicador | x5 | `ScoreCounterManager.max_multiplier` |
| Duração da janela do combo | 3 s | `ScoreCounterManager.combo_duration` |
| Timeout de inatividade | 20 s | `InactivityManager.max_counter_time` |

Todos são `@export` — configuráveis pelo inspector, sem tocar em código.

**O multiplicador é temporário.** A cada 5 acertos seguidos ele sobe um degrau (x2, x3… até x5)
e abre uma janela de 3 segundos. Se o jogador demorar, a janela expira e ele volta a x1 —
não dá para "guardar" um multiplicador jogando devagar. Errar derruba o multiplicador **e**
zera a sequência, mas **não tira pontos**.

---

## Estatísticas da partida

Além da pontuação, cada partida grava duas medidas, mostradas na tela de resultado e usadas
para desempatar o ranking:

| Medida | O que é | Onde nasce |
|---|---|---|
| **Sequência máxima** | O maior número de acertos seguidos que a partida chegou a ter | `ScoreCounterManager.max_sequence_combo` |
| **Tempo médio de reação** | Segundos entre um acerto e o seguinte, em média | `ScoreCounterManager.get_average_reaction_time()` |

A sequência máxima é atualizada **a cada acerto**, e não no fim da partida: um erro zera a
sequência atual, então ler o contador no `game_over` devolveria a sequência final, não a maior.

O cronômetro de reação só corre **durante** a partida (`BatakiTimer.can_run`). Sem isso, o tempo
parado na tela antes do primeiro toque — e o tempo depois do fim — entraria na conta e inflaria
a média. A medida vai de um acerto ao próximo, então erros no meio do caminho **contam** para o
tempo: é "quanto o jogador demorou para acertar", não a reação pura desde o bataki acender.

### Ordenação do ranking

```sql
ORDER BY score DESC,
		 max_seq DESC,
		 CASE WHEN avg_time > 0 THEN avg_time ELSE 1e9 END ASC,
		 date_time ASC
```

O `CASE` existe porque `avg_time = 0` significa "não acertou nada", e não "reagiu
instantaneamente". Um `ASC` ingênuo colocaria quem não pontuou na frente de todo mundo no
desempate. Empate total é resolvido por quem pontuou primeiro.

---

## Decisões técnicas

**SQLite em vez de MySQL.** O jogo roda offline num totem de evento. Um banco cliente-servidor
exigiria um servidor no local e colocaria a credencial dentro do executável — qualquer pessoa
com o `.exe` extrairia a string de conexão. SQLite é um arquivo local, sem servidor, e ainda
assim é SQL de verdade: abre em qualquer cliente para exportar os leads no fim do evento.

**O schema mora no código, não numa ferramenta.** Um `CREATE TABLE IF NOT EXISTS` no `_ready()`
significa que a máquina do cliente cria o próprio banco na primeira partida. Não há script de
instalação para esquecer de rodar, nem arquivo de banco para versionar.

**A lógica de jogo não conhece a interface.** Além de ser o que o teste pede, isso tem um
efeito prático: as regras podem ser exercitadas sem abrir uma cena. Bugs de pontuação foram
encontrados exatamente assim, instanciando `ScoreCounterManager.new()` direto.

**Um único dono da navegação.** As rotas de cena estavam espalhadas por cinco scripts, e as duas
que levavam à contagem regressiva divergiram em silêncio — "Jogar de novo" abria uma versão sem
fundo nem logo. Centralizar no `ScreenFlow` tornou esse tipo de erro impossível por construção.

---

## Pendência conhecida

**Zerar o ranking exige código.** O `clear_all()` existe e funciona, mas não há gatilho na
interface — no evento, a única forma sem terminal é apagar o `bataki.db`. Falta pendurá-lo em
algo discreto (uma tecla, um toque longo num canto da Home).
