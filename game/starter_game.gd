class_name StarterGame
extends RefCounted
## One place to name the scenes and values used by the replaceable starter loop.

const HOME_SCENE := "res://game/starter_home.tscn"
const RUN_SCENE := "res://game/starter_run.tscn"
const RUN_ID: StringName = &"starter_expedition"
const BASE_MOVE_SPEED := 72.0
const BASE_REWARD_MULTIPLIER := 1.0


static func create_run_context() -> RunContext:
	return RunContext.new(
		RUN_ID,
		RUN_SCENE,
		HOME_SCENE,
		"Starter Expedition",
		{
			&"move_speed": Progression.get_effective_stat(&"run_speed", BASE_MOVE_SPEED),
			&"reward_multiplier": Progression.get_effective_stat(
				&"run_reward_multiplier",
				BASE_REWARD_MULTIPLIER,
			),
		},
	)
