class_name GameDefinition
extends RefCounted
## Scene paths and upgrade values for the home/gameplay example.

const HOME_SCENE := "res://game/home.tscn"
const RUN_SCENE := "res://game/gameplay.tscn"
# Preserve this stable ID so renaming files does not change session identity.
const RUN_ID: StringName = &"starter_expedition"
const BASE_MOVE_SPEED := 72.0
const BASE_REWARD_MULTIPLIER := 1.0


static func create_run_context() -> RunContext:
	return RunContext.new(
		RUN_ID,
		RUN_SCENE,
		HOME_SCENE,
		"Expedition",
		{
			&"pickup_radius": Progression.get_effective_stat(&"pickup_radius", 7.0),
			&"bonus_gold": Progression.get_effective_stat(&"bonus_gold", 0.0),
			&"insight_reward": Progression.get_effective_stat(&"insight_reward", 1.0),
			&"move_speed": Progression.get_effective_stat(&"run_speed", BASE_MOVE_SPEED),
			&"reward_multiplier": Progression.get_effective_stat(
				&"run_reward_multiplier",
				BASE_REWARD_MULTIPLIER,
			),
		},
	)
