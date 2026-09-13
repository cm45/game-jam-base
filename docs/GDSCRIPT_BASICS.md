# GDScript starter exercises

These small exercises let a first-time programmer practice in a disposable
sandbox before changing the foundation. Create files under game/sandbox/ and
delete them when finished. None of these exercises are required by the project.

## 1. Print a greeting

Create a Node scene, attach a script, and add:

~~~gdscript
extends Node

func _ready() -> void:
	print("The game jam starts here!")
~~~

Run the scene and find the text in Godot's Output panel. The function named
_ready runs once after the node enters the scene tree.

## 2. Change a typed value

Add a variable and a function:

~~~gdscript
var gold: int = 0

func add_gold(amount: int) -> void:
	gold += amount
	print("Gold: ", gold)
~~~

Call add_gold(5) from _ready. Change the amount and run again. This is the
same shape used later for resources, scores, and counters.

## 3. Send a signal

A signal lets one node announce that something happened without knowing who is
listening.

~~~gdscript
signal treasure_found(amount: int)

func find_treasure() -> void:
	treasure_found.emit(3)
~~~

Connect treasure_found to a method in the Node dock, then print the received
amount. Use signals later for UI updates and interactions instead of making
unrelated nodes reach into one another.

## 4. Export a designer-friendly value

~~~gdscript
@export var move_speed: float = 120.0
~~~

Select the node in Godot and change Move Speed in the Inspector. Exports make
simple tuning possible without editing code. Give exported values defaults that
make a new scene safe to run.

## Next practice

When these feel comfortable, read [the architecture overview](ARCHITECTURE.md)
and use the Godot Foundation Planner agent to describe the smallest feature you
want to build. Keep the first version runnable before adding a second idea.
