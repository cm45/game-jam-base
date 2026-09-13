class_name ProgressionCatalog
extends Resource
## The editable list of currencies and upgrades used by Progression.

@export var currencies: Array[CurrencyDefinition] = []
@export var upgrades: Array[UpgradeDefinition] = []


func get_currency(currency_id: StringName) -> CurrencyDefinition:
	for currency: CurrencyDefinition in currencies:
		if currency.id == currency_id:
			return currency
	return null


func get_upgrade(upgrade_id: StringName) -> UpgradeDefinition:
	for upgrade: UpgradeDefinition in upgrades:
		if upgrade.id == upgrade_id:
			return upgrade
	return null
