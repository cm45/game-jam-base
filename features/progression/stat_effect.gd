class_name StatEffect
extends Resource
## A deterministic permanent value applied by an owned upgrade level.

enum Operation {
	ADD,
	MULTIPLY,
}

@export var stat_id: StringName
@export var operation: Operation = Operation.ADD
@export var value := 0.0


func describe() -> String:
	match operation:
		Operation.MULTIPLY:
			return "%s x%.2f" % [String(stat_id).capitalize(), value]
		_:
			return "%s %s%s" % [String(stat_id).capitalize(), "+" if value >= 0.0 else "", str(value)]
