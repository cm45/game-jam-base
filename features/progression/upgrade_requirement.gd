class_name UpgradeRequirement
extends Resource
## Requires a particular level in another upgrade before purchase.

@export var upgrade_id: StringName
@export_range(1, 99, 1) var required_level := 1
