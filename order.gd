class_name Order
extends RefCounted

## Represents a customer order at the counter.
## Each order occupies one of the 4 order slots.
## Customers request specific toppings, but the player has full freedom
## in assembling the pizza. The order is reviewed when served.

signal status_changed(new_status: Status)
signal order_reviewed(review_data: Dictionary)
signal order_expired()

enum Status {
	EMPTY,            ## No customer in this slot
	WAITING_TO_TAKE,  ## Customer waiting; player must type "take order {number}"
	ACTIVE,           ## Order taken; ingredients visible; waiting for pizza
	SERVED,           ## Order has been served and reviewed
	EXPIRED           ## Customer waited too long and left
}

## The slot number (1 to 4) this order is assigned to
var slot_number: int = 1

## The display order number (e.g. 101, 102...)
var order_number: int = 101

## Customer requested toppings (e.g. ["SAUCE", "CHEESE", "PEPPERONI"])
var requested_toppings: Array[String] = []

## Current status of this order slot
var status: Status = Status.EMPTY

## Patience timers in seconds (longer, generous timers)
var patience_waiting_to_order: float = 80.0
var patience_waiting_for_food: float = 130.0
var patience: float = 80.0
var max_patience: float = 80.0

## Last review report after serving
var last_review: Dictionary = {}


func _init(p_slot_number: int = 1, p_order_number: int = 101, p_toppings: Array[String] = [], p_order_patience: float = 80.0, p_food_patience: float = 130.0) -> void:
	slot_number = p_slot_number
	order_number = p_order_number
	requested_toppings = p_toppings.duplicate()
	patience_waiting_to_order = p_order_patience
	patience_waiting_for_food = p_food_patience
	max_patience = p_order_patience
	patience = p_order_patience
	status = Status.WAITING_TO_TAKE if requested_toppings.size() > 0 else Status.EMPTY


## Player types "take order {number}"
func take_order() -> bool:
	if status == Status.WAITING_TO_TAKE:
		status = Status.ACTIVE
		# Give a full fresh timer for waiting for food!
		max_patience = patience_waiting_for_food
		patience = patience_waiting_for_food
		status_changed.emit(status)
		return true
	return false


## Updates customer patience while waiting
func update_patience(delta: float) -> void:
	if status == Status.WAITING_TO_TAKE or status == Status.ACTIVE:
		patience -= delta
		if patience <= 0.0:
			patience = 0.0
			status = Status.EXPIRED
			status_changed.emit(status)
			order_expired.emit()


## Reviews the given pizza when player types "give {number}".
## Evaluates dough presence, toppings, cook time / doneness, and slicing.
func review_pizza(pizza: Pizza) -> Dictionary:
	var feedback: Array[String] = []
	var total_score: float = 0.0

	# 1. Dough Evaluation (20 points)
	var dough_score: float = 20.0
	total_score += dough_score

	# 2. Topping Evaluation (40 points)
	var matched_toppings: Array[String] = []
	var missing_toppings: Array[String] = []
	var extra_toppings: Array[String] = []

	var requested_copy = requested_toppings.duplicate()
	var pizza_toppings_copy = pizza.toppings.duplicate()

	for req in requested_copy:
		var found_index = pizza_toppings_copy.find(req)
		if found_index != -1:
			matched_toppings.append(req)
			pizza_toppings_copy.remove_at(found_index)
		else:
			missing_toppings.append(req)

	extra_toppings = pizza_toppings_copy

	var topping_score: float = 0.0
	if requested_toppings.is_empty():
		topping_score = 40.0 if extra_toppings.is_empty() else 20.0
	else:
		var match_ratio = float(matched_toppings.size()) / float(requested_toppings.size())
		topping_score = match_ratio * 40.0
		topping_score -= extra_toppings.size() * 5.0
		topping_score = clampf(topping_score, 0.0, 40.0)

	if missing_toppings.size() > 0:
		feedback.append("Missing: %s." % ", ".join(missing_toppings))
	if extra_toppings.size() > 0:
		feedback.append("Extra toppings: %s." % ", ".join(extra_toppings))
	if missing_toppings.is_empty() and extra_toppings.is_empty() and requested_toppings.size() > 0:
		feedback.append("Toppings are spot on!")

	total_score += topping_score

	# 3. Cook Time / Doneness Evaluation (25 points)
	var doneness = pizza.get_doneness()
	var cook_score: float = 0.0
	match doneness:
		Pizza.Doneness.PERFECT:
			cook_score = 25.0
			feedback.append("Baked to perfection!")
		Pizza.Doneness.UNDERCOOKED:
			cook_score = 12.0
			feedback.append("A bit undercooked.")
		Pizza.Doneness.OVERCOOKED:
			cook_score = 12.0
			feedback.append("A bit overcooked.")
		Pizza.Doneness.RAW:
			cook_score = 0.0
			feedback.append("Completely raw!")
		Pizza.Doneness.BURNT:
			cook_score = 0.0
			feedback.append("Completely burnt!")

	total_score += cook_score

	# 4. Slicing Evaluation (15 points)
	var slice_score: float = 0.0
	if pizza.is_sliced:
		slice_score = 15.0
	else:
		feedback.append("Not sliced!")
	total_score += slice_score

	# Calculate Stars (1 to 5)
	var stars: int = 1
	if total_score >= 90.0:
		stars = 5
	elif total_score >= 75.0:
		stars = 4
	elif total_score >= 55.0:
		stars = 3
	elif total_score >= 35.0:
		stars = 2
	else:
		stars = 1

	last_review = {
		"slot_number": slot_number,
		"order_number": order_number,
		"score": roundi(total_score),
		"stars": stars,
		"doneness": pizza.get_doneness_name(),
		"cook_time": pizza.cook_time,
		"matched_toppings": matched_toppings,
		"missing_toppings": missing_toppings,
		"extra_toppings": extra_toppings,
		"is_sliced": pizza.is_sliced,
		"is_boxed": pizza.is_boxed,
		"feedback": feedback
	}

	status = Status.SERVED
	status_changed.emit(status)
	order_reviewed.emit(last_review)
	return last_review
