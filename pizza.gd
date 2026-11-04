class_name Pizza
extends RefCounted

## Represents a pizza in the restaurant.
## A new Pizza instance is created whenever MAKE DOUGH runs.
## Any toppings can be added, baked in an oven for any duration,
## sliced on the counter, and packed into a box.

enum Doneness {
	RAW,
	UNDERCOOKED,
	PERFECT,
	OVERCOOKED,
	BURNT
}

## Cooking duration thresholds (in seconds)
const TIME_UNDERCOOKED: float = 8.0
const TIME_PERFECT_MIN: float = 16.0
const TIME_PERFECT_MAX: float = 28.0
const TIME_BURNT: float = 40.0

## Toppings currently on this pizza
var toppings: Array[String] = []

## Oven & baking state
var is_in_oven: bool = false
var oven_slot: int = -1 # 1 to 4, or -1 when not in an oven
var cook_time: float = 0.0

## Counter preparation states
var is_sliced: bool = false
var is_boxed: bool = false


func _init() -> void:
	toppings = []
	is_in_oven = false
	oven_slot = -1
	cook_time = 0.0
	is_sliced = false
	is_boxed = false


## Adds a topping (e.g. "CHEESE", "PEPPERONI", "SAUCE", "MUSHROOMS").
func add_topping(topping_name: String) -> bool:
	var formatted = topping_name.strip_edges().to_upper()
	toppings.append(formatted)
	return true


## Checks if the pizza has a specific topping.
func has_topping(topping_name: String) -> bool:
	var formatted = topping_name.strip_edges().to_upper()
	return toppings.has(formatted)


## Places pizza into an oven slot.
func put_in_oven(slot: int) -> void:
	is_in_oven = true
	oven_slot = slot


## Updates cooking time while inside the oven.
func bake(delta: float) -> void:
	if is_in_oven:
		cook_time += delta


## Takes the pizza out of its oven slot.
func take_out_of_oven() -> void:
	is_in_oven = false
	oven_slot = -1


## Evaluates doneness based on how long it was baked in the oven.
func get_doneness() -> Doneness:
	if cook_time < TIME_UNDERCOOKED:
		return Doneness.RAW
	elif cook_time < TIME_PERFECT_MIN:
		return Doneness.UNDERCOOKED
	elif cook_time <= TIME_PERFECT_MAX:
		return Doneness.PERFECT
	elif cook_time < TIME_BURNT:
		return Doneness.OVERCOOKED
	else:
		return Doneness.BURNT


## Human-readable string for current doneness.
func get_doneness_name() -> String:
	match get_doneness():
		Doneness.RAW:
			return "Raw"
		Doneness.UNDERCOOKED:
			return "Undercooked"
		Doneness.PERFECT:
			return "Perfect"
		Doneness.OVERCOOKED:
			return "Overcooked"
		Doneness.BURNT:
			return "Burnt"
	return "Unknown"


## Slices the pizza at the slicing counter.
func slice() -> bool:
	if not is_sliced:
		is_sliced = true
		return true
	return false


## Packs the pizza into a box at the packing station.
## Must be sliced before it can be boxed.
func box() -> bool:
	if is_sliced and not is_boxed:
		is_boxed = true
		return true
	return false
