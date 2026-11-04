extends Control

@onready var counter: Control = $Counter
@onready var kitchen: Control = $Kitchen

## Pizzeria state engine
var pizzeria: PizzeriaState = PizzeriaState.new()

## -------------------------------------------------------------
## TEXTURE ASSETS
## -------------------------------------------------------------
var tex_uncooked: Texture2D = null
var tex_cooked: Texture2D = null
var tex_sauce: Texture2D = null
var tex_cheese_unmelted: Texture2D = null
var tex_cheese_melted: Texture2D = null
var tex_pepperoni: Texture2D = null

## -------------------------------------------------------------
## COUNTER NODE REFERENCES
## -------------------------------------------------------------
@onready var order_slot_nodes = [
	{
		"container": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot1,
		"title": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot1/MarginContainer/VBoxContainer/TitleLbl,
		"toppings": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot1/MarginContainer/VBoxContainer/ToppingLbl,
		"take_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot1/MarginContainer/VBoxContainer/TakeOrder,
		"give_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot1/MarginContainer/VBoxContainer/GiveOrder,
	},
	{
		"container": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot2,
		"title": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot2/MarginContainer/VBoxContainer/TitleLbl,
		"toppings": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot2/MarginContainer/VBoxContainer/ToppingLbl,
		"take_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot2/MarginContainer/VBoxContainer/TakeOrder,
		"give_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot2/MarginContainer/VBoxContainer/GiveOrder,
	},
	{
		"container": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot3,
		"title": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot3/MarginContainer/VBoxContainer/TitleLbl,
		"toppings": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot3/MarginContainer/VBoxContainer/ToppingLbl,
		"take_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot3/MarginContainer/VBoxContainer/TakeOrder,
		"give_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot3/MarginContainer/VBoxContainer/GiveOrder,
	},
	{
		"container": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot4,
		"title": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot4/MarginContainer/VBoxContainer/TitleLbl,
		"toppings": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot4/MarginContainer/VBoxContainer/ToppingLbl,
		"take_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot4/MarginContainer/VBoxContainer/TakeOrder,
		"give_order": $Counter/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/OrderCont/OrderSlot4/MarginContainer/VBoxContainer/GiveOrder,
	}
]

@onready var slice_label: RichTextLabel = $Counter/MarginContainer/VBoxContainer/CounterCont/SlicePanel/MarginContainer/VBoxContainer/Slice
@onready var slice_texture: TextureRect = $Counter/MarginContainer/VBoxContainer/CounterCont/SlicePanel/MarginContainer/VBoxContainer/TextureRect

@onready var pack_up_label: RichTextLabel = $Counter/MarginContainer/VBoxContainer/CounterCont/BoxPanel/MarginContainer/VBoxContainer/PackUp
@onready var box_texture: TextureRect = $Counter/MarginContainer/VBoxContainer/CounterCont/BoxPanel/MarginContainer/VBoxContainer/TextureRect

@onready var counter_trash_label: RichTextLabel = $Counter/MarginContainer/VBoxContainer/CounterCont/VBoxContainer/Trash

## -------------------------------------------------------------
## KITCHEN NODE REFERENCES
## -------------------------------------------------------------
@onready var sauce_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/IngPanel/MarginContainer/VBoxContainer/Sauce
@onready var cheese_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/IngPanel/MarginContainer/VBoxContainer/Cheese
@onready var pepperoni_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/IngPanel/MarginContainer/VBoxContainer/Pepperoni
@onready var make_dough_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/IngPanel/MarginContainer/VBoxContainer/MakeDough

@onready var add_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/PizzaPanel/MarginContainer/VBoxContainer/Add
@onready var kitchen_pizza_texture: TextureRect = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/PizzaPanel/MarginContainer/VBoxContainer/TextureRect
@onready var into_oven_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/PizzaPanel/MarginContainer/VBoxContainer/IntoOven
@onready var kitchen_trash_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/MainPanel/MarginContainer/HBoxContainer/PizzaPanel/MarginContainer/VBoxContainer/Trash

@onready var take_out_label: RichTextLabel = $Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/TakeOut

@onready var oven_slot_labels: Array[RichTextLabel] = [
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel1/TextureRect.get_node("1") as RichTextLabel,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel2/TextureRect.get_node("2") as RichTextLabel,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel3/TextureRect.get_node("3") as RichTextLabel,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel4/TextureRect.get_node("4") as RichTextLabel
]

@onready var oven_textures: Array[TextureRect] = [
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel1/TextureRect,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel2/TextureRect,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel3/TextureRect,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel4/TextureRect
]

@onready var oven_progress_bars: Array[ProgressBar] = [
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel1/ProgressBar,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel2/ProgressBar,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel3/ProgressBar,
	$Kitchen/MarginContainer/HBoxContainer/OvenPanel/MarginContainer/VBoxContainer/OvenPanel4/ProgressBar
]

## Active command descriptor structures:
## { "command": String, "completion": int, "label": RichTextLabel, "prefix": String, "action": String }
var active_kitchen_targets: Array[Dictionary] = []
var active_counter_targets: Array[Dictionary] = []

## Order spawner timer
var order_timer: float = 0.0
const ORDER_INTERVAL: float = 20.0


func _ready() -> void:
	# Load image textures
	tex_uncooked = load("res://images/pizza_uncooked.png")
	tex_cooked = load("res://images/pizza_cooked.png")
	tex_sauce = load("res://images/sauce.png")
	tex_cheese_unmelted = load("res://images/cheese_unmelted.png")
	tex_cheese_melted = load("res://images/cheese_melted.png")
	tex_pepperoni = load("res://images/pepperoni.png")

	# Configure progress bars (normalized 0.0 to 1.0 for stage-based filling)
	for bar in oven_progress_bars:
		bar.min_value = 0.0
		bar.max_value = 1.0
		bar.value = 0.0
		get_or_create_stage_label(bar)

	# Connect pizzeria signals
	pizzeria.kitchen_table_changed.connect(_on_state_updated)
	pizzeria.oven_changed.connect(_on_oven_updated)
	pizzeria.slice_queue_changed.connect(_on_state_updated)
	pizzeria.packing_station_changed.connect(_on_state_updated)
	pizzeria.order_slot_changed.connect(_on_order_updated)
	pizzeria.order_reviewed.connect(_on_order_reviewed)

	# Spawn initial customer orders with generous waiting times
	pizzeria.spawn_order(1, ["SAUCE", "CHEESE", "PEPPERONI"], 90.0, 150.0)
	pizzeria.spawn_order(2, ["CHEESE"], 80.0, 130.0)

	refresh_ui()


func _process(delta: float) -> void:
	# Update simulation (baking timers, customer patience)
	pizzeria.update(delta)

	# Customer order spawner
	order_timer += delta
	if order_timer >= ORDER_INTERVAL:
		order_timer = 0.0
		spawn_random_order()

	# Dimension switch: Hold Shift for Kitchen, release for Counter
	if Input.is_action_pressed("hold_shift"):
		counter.hide()
		kitchen.show()
	else:
		kitchen.hide()
		counter.show()

	# Continuously update dynamic displays (patience countdowns, oven bars & stages)
	update_order_cards()
	update_oven_progress()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SHIFT or event.keycode == KEY_CAPSLOCK:
			return

		var typed_char = char(event.unicode)
		var is_kitchen = Input.is_action_pressed("hold_shift")

		# Normalize casing by dimension so Caps Lock never breaks typing
		if is_kitchen:
			# In kitchen, holding Shift produces symbols for top-row numbers.
			# Map symbols and keycodes to '1', '2', '3', '4' so '! ' counts as '1', etc.
			if typed_char == "!" or event.physical_keycode == KEY_1 or event.keycode == KEY_1 or event.keycode == KEY_KP_1:
				typed_char = "1"
			elif typed_char == "@" or typed_char == "\"" or event.physical_keycode == KEY_2 or event.keycode == KEY_2 or event.keycode == KEY_KP_2:
				typed_char = "2"
			elif typed_char == "#" or typed_char == "+" or event.physical_keycode == KEY_3 or event.keycode == KEY_3 or event.keycode == KEY_KP_3:
				typed_char = "3"
			elif typed_char == "$" or typed_char == "%" or event.physical_keycode == KEY_4 or event.keycode == KEY_4 or event.keycode == KEY_KP_4:
				typed_char = "4"
			else:
				# Kitchen commands are always UPPERCASE
				typed_char = typed_char.to_upper()
		else:
			# Counter commands are always lowercase, regardless of Caps Lock state
			typed_char = typed_char.to_lower()

		if typed_char.length() == 0:
			return

		var targets = active_kitchen_targets if is_kitchen else active_counter_targets
		var completed_action: String = ""

		for item in targets:
			var command: String = item["command"]
			var current_comp: int = item["completion"]

			if current_comp < command.length():
				var expected_char = command[current_comp]
				if typed_char == expected_char:
					item["completion"] = current_comp + 1
				else:
					item["completion"] = 0

			if item["completion"] >= command.length():
				completed_action = item.get("action", command)
				item["completion"] = 0

		render_all_targets(targets, is_kitchen)

		if completed_action != "":
			print("Executed: ", completed_action)
			pizzeria.execute_command(completed_action)
			refresh_ui()


## Rebuilds active typing targets and syncs station visuals.
func refresh_ui() -> void:
	build_counter_targets()
	build_kitchen_targets()
	update_order_cards()
	update_counter_station_visuals()
	update_kitchen_station_visuals()
	update_oven_progress()


## -------------------------------------------------------------
## TYPING TARGET REGISTRATION
## -------------------------------------------------------------

func build_counter_targets() -> void:
	var old_completions = {}
	for t in active_counter_targets:
		old_completions[t["command"]] = t["completion"]

	active_counter_targets.clear()

	# 1. Order cards: "take order {num}" or "give {num}"
	for i in range(4):
		var order = pizzeria.order_slots[i]
		if order != null:
			if order.status == Order.Status.WAITING_TO_TAKE:
				var cmd = "take order %d" % order.order_number
				active_counter_targets.append({
					"command": cmd,
					"completion": old_completions.get(cmd, 0),
					"label": order_slot_nodes[i]["take_order"],
					"prefix": "",
					"action": cmd
				})
			elif order.status == Order.Status.ACTIVE and pizzeria.packing_station_pizza != null:
				var cmd = "give %d" % order.order_number
				active_counter_targets.append({
					"command": cmd,
					"completion": old_completions.get(cmd, 0),
					"label": order_slot_nodes[i]["give_order"],
					"prefix": "",
					"action": cmd
				})

	# 2. Slice station: "slice"
	if not pizzeria.slice_queue.is_empty() and not pizzeria.slice_queue[0].is_sliced:
		active_counter_targets.append({
			"command": "slice",
			"completion": old_completions.get("slice", 0),
			"label": slice_label,
			"prefix": "",
			"action": "slice"
		})

	# 3. Packing box station: "pack up"
	if not pizzeria.slice_queue.is_empty() and pizzeria.slice_queue[0].is_sliced and pizzeria.packing_station_pizza == null:
		active_counter_targets.append({
			"command": "pack up",
			"completion": old_completions.get("pack up", 0),
			"label": pack_up_label,
			"prefix": "",
			"action": "pack up"
		})

	# 4. Trash station: "trash"
	if pizzeria.packing_station_pizza != null:
		active_counter_targets.append({
			"command": "trash",
			"completion": old_completions.get("trash", 0),
			"label": counter_trash_label,
			"prefix": "",
			"action": "trash"
		})

	render_all_targets(active_counter_targets, false)


func build_kitchen_targets() -> void:
	var old_completions = {}
	for t in active_kitchen_targets:
		old_completions[t["command"]] = t["completion"]

	active_kitchen_targets.clear()

	# 1. Main table empty: "MAKE DOUGH"
	if pizzeria.kitchen_table_pizza == null:
		active_kitchen_targets.append({
			"command": "MAKE DOUGH",
			"completion": old_completions.get("MAKE DOUGH", 0),
			"label": make_dough_label,
			"prefix": "",
			"action": "MAKE DOUGH"
		})
	else:
		# 2. Pizza on table: Ingredients ("ADD SAUCE", "ADD CHEESE", "ADD PEPPERONI")
		# STRICT: Typing just "CHEESE" does not work. You MUST type out "ADD CHEESE".
		var topping_labels = {
			"SAUCE": sauce_label,
			"CHEESE": cheese_label,
			"PEPPERONI": pepperoni_label
		}

		for topping in pizzeria.available_toppings:
			var lbl = topping_labels.get(topping)
			if lbl != null:
				var full_cmd = "ADD %s" % topping
				active_kitchen_targets.append({
					"command": full_cmd,
					"completion": old_completions.get(full_cmd, 0),
					"label": lbl,
					"prefix": "ADD ",
					"action": full_cmd
				})

		# 3. "INTO OVEN"
		if pizzeria.ovens.has(null):
			active_kitchen_targets.append({
				"command": "INTO OVEN",
				"completion": old_completions.get("INTO OVEN", 0),
				"label": into_oven_label,
				"prefix": "",
				"action": "INTO OVEN"
			})

		# 4. "TRASH"
		active_kitchen_targets.append({
			"command": "TRASH",
			"completion": old_completions.get("TRASH", 0),
			"label": kitchen_trash_label,
			"prefix": "",
			"action": "TRASH"
		})

	# 5. Ovens: "TAKE OUT 1", "TAKE OUT 2", etc.
	for i in range(4):
		if pizzeria.ovens[i] != null:
			var slot_num = i + 1
			var cmd = "TAKE OUT %d" % slot_num
			active_kitchen_targets.append({
				"command": cmd,
				"completion": old_completions.get(cmd, 0),
				"label": oven_slot_labels[i],
				"prefix": "TAKE OUT ",
				"action": cmd
			})

	render_all_targets(active_kitchen_targets, true)


## Renders green BBCode highlight for all targets, aggregating shared prefixes correctly,
## and disables/dims ingredients and oven numbers until their prefix ("ADD " / "TAKE OUT ") is typed.
func render_all_targets(targets: Array[Dictionary], is_kitchen: bool) -> void:
	if is_kitchen:
		var has_pizza = (pizzeria.kitchen_table_pizza != null)

		# Calculate shared prefix progression
		var max_add_comp: int = 0
		var max_takeout_comp: int = 0

		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			if cmd.begins_with("ADD "):
				max_add_comp = maxi(max_add_comp, mini(comp, 4))
			elif cmd.begins_with("TAKE OUT "):
				max_takeout_comp = maxi(max_takeout_comp, mini(comp, 9))

		# Render ADD prefix label above prep table
		var add_pref = "ADD "
		var typed_add = add_pref.substr(0, max_add_comp)
		var untyped_add = add_pref.substr(max_add_comp)
		add_label.text = "[color=green]" + typed_add + "[/color]" + untyped_add
		add_label.modulate = Color(1, 1, 1, 1.0) if has_pizza else Color(1, 1, 1, 0.3)

		# INGREDIENTS ARE DISABLED/DIMMED UNTIL "ADD " IS TYPED!
		var ing_enabled = has_pizza and (max_add_comp >= 4)
		var ing_color = Color(1, 1, 1, 1.0) if ing_enabled else Color(1, 1, 1, 0.3)
		sauce_label.modulate = ing_color
		cheese_label.modulate = ing_color
		pepperoni_label.modulate = ing_color

		# Render TAKE OUT prefix label above ovens
		var any_baking = pizzeria.ovens.any(func(p): return p != null)
		var to_pref = "TAKE OUT "
		var typed_to = to_pref.substr(0, max_takeout_comp)
		var untyped_to = to_pref.substr(max_takeout_comp)
		take_out_label.text = "[color=green]" + typed_to + "[/color]" + untyped_to
		take_out_label.modulate = Color(1, 1, 1, 1.0) if any_baking else Color(1, 1, 1, 0.3)

		# OVEN NUMBERS ARE DISABLED/DIMMED UNTIL "TAKE OUT " IS TYPED!
		var ovens_active = any_baking and (max_takeout_comp >= 9)

		# Render individual labels
		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			var label: RichTextLabel = item.get("label")
			var prefix: String = item.get("prefix", "")

			if label == null:
				continue

			if prefix != "":
				var pref_len = prefix.length()
				var suffix = cmd.substr(pref_len)
				if comp > pref_len:
					var suf_comp = comp - pref_len
					var typed = suffix.substr(0, suf_comp)
					var untyped = suffix.substr(suf_comp)
					label.text = "[color=green]" + typed + "[/color]" + untyped
				else:
					label.text = suffix
			else:
				var typed = cmd.substr(0, comp)
				var untyped = cmd.substr(comp)
				label.text = "[color=green]" + typed + "[/color]" + untyped

		# Apply dimming to oven numbers based on prefix state
		for i in range(4):
			var has_oven_pizza = (pizzeria.ovens[i] != null)
			if has_oven_pizza and ovens_active:
				oven_slot_labels[i].modulate = Color(1, 1, 1, 1.0)
			else:
				oven_slot_labels[i].modulate = Color(1, 1, 1, 0.25)
	else:
		# Counter targets
		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			var label: RichTextLabel = item.get("label")

			if label != null:
				var typed = cmd.substr(0, comp)
				var untyped = cmd.substr(comp)
				label.text = "[color=green]" + typed + "[/color]" + untyped


## -------------------------------------------------------------
## VISUAL SYNCHRONIZATION & PIZZA RENDERING
## -------------------------------------------------------------

## Renders a pizza with its layered ingredients and bake stage textures.
func update_pizza_display(base_rect: TextureRect, pizza: Pizza) -> void:
	if base_rect == null:
		return

	if pizza == null:
		base_rect.texture = null
		for child in base_rect.get_children():
			if child is TextureRect:
				child.hide()
		return

	base_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	base_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Choose dough base: cooked if baked/overcooked/burnt, uncooked otherwise
	var doneness = pizza.get_doneness()
	var is_cooked = (doneness != Pizza.Doneness.RAW and doneness != Pizza.Doneness.UNDERCOOKED)
	base_rect.texture = tex_cooked if is_cooked else tex_uncooked

	# Sauce layer
	var sauce_node = get_or_create_layer(base_rect, "SauceLayer", tex_sauce)
	sauce_node.visible = pizza.has_topping("SAUCE")

	# Cheese layer (unmelted or melted depending on bake stage)
	var cheese_tex = tex_cheese_melted if is_cooked else tex_cheese_unmelted
	var cheese_node = get_or_create_layer(base_rect, "CheeseLayer", cheese_tex)
	cheese_node.texture = cheese_tex
	cheese_node.visible = pizza.has_topping("CHEESE")

	# Pepperoni layer
	var pep_node = get_or_create_layer(base_rect, "PepLayer", tex_pepperoni)
	pep_node.visible = pizza.has_topping("PEPPERONI")

	# If burnt, tint darker
	if doneness == Pizza.Doneness.BURNT:
		base_rect.self_modulate = Color(0.35, 0.25, 0.25)
	else:
		base_rect.self_modulate = Color(1, 1, 1)


func get_or_create_layer(parent: TextureRect, layer_name: String, tex: Texture2D) -> TextureRect:
	var layer = parent.get_node_or_null(layer_name) as TextureRect
	if layer == null:
		layer = TextureRect.new()
		layer.name = layer_name
		layer.set_anchors_preset(Control.PRESET_FULL_RECT)
		layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		layer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(layer)
	layer.texture = tex
	return layer


func get_or_create_stage_label(bar: ProgressBar) -> Label:
	var lbl = bar.get_node_or_null("StageLabel") as Label
	if lbl == null:
		lbl = Label.new()
		lbl.name = "StageLabel"
		lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 13)
		bar.add_child(lbl)
	return lbl


func update_order_cards() -> void:
	for i in range(4):
		var order = pizzeria.order_slots[i]
		var nodes = order_slot_nodes[i]

		# ToppingLbl is a plain Label, so NO BBCode tags are used here!
		if order == null or order.status == Order.Status.EMPTY:
			nodes["title"].text = "Slot %d" % (i + 1)
			nodes["toppings"].text = "(Empty Slot)"
			nodes["take_order"].hide()
			nodes["give_order"].hide()
		elif order.status == Order.Status.WAITING_TO_TAKE:
			nodes["title"].text = "Order #%d (%.0fs)" % [order.order_number, order.patience]
			nodes["toppings"].text = "Customer Waiting!\n%.0fs left to take order\n\n(Take order to view)" % order.patience
			nodes["take_order"].show()
			nodes["give_order"].hide()
		elif order.status == Order.Status.ACTIVE:
			nodes["title"].text = "Order #%d (%.0fs)" % [order.order_number, order.patience]
			var top_str = "Time Left: %.0fs\nToppings:" % order.patience
			for t in order.requested_toppings:
				top_str += "\n + " + t.capitalize()
			nodes["toppings"].text = top_str
			nodes["take_order"].hide()
			nodes["give_order"].visible = (pizzeria.packing_station_pizza != null)
		elif order.status == Order.Status.SERVED:
			nodes["title"].text = "Order #%d" % order.order_number
			nodes["toppings"].text = "Served!\nScore: %d%%\n%d Stars" % [order.last_review.get("score", 0), order.last_review.get("stars", 1)]
			nodes["take_order"].hide()
			nodes["give_order"].hide()
		elif order.status == Order.Status.EXPIRED:
			nodes["title"].text = "Order #%d" % order.order_number
			nodes["toppings"].text = "Customer Left!"
			nodes["take_order"].hide()
			nodes["give_order"].hide()


func update_counter_station_visuals() -> void:
	# Slice station
	if pizzeria.slice_queue.is_empty():
		slice_label.text = "slice"
		slice_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(slice_texture, null)
	elif not pizzeria.slice_queue[0].is_sliced:
		slice_label.text = "slice"
		slice_label.modulate = Color(1, 1, 1, 1.0)
		update_pizza_display(slice_texture, pizzeria.slice_queue[0])
	else:
		slice_label.text = "sliced!"
		slice_label.modulate = Color(0.4, 1.0, 0.4, 0.8)
		update_pizza_display(slice_texture, pizzeria.slice_queue[0])

	# Box station
	if pizzeria.packing_station_pizza != null:
		pack_up_label.text = "boxed"
		pack_up_label.modulate = Color(1.0, 0.85, 0.3, 1.0)
		counter_trash_label.modulate = Color(1, 1, 1, 1.0)
		update_pizza_display(box_texture, pizzeria.packing_station_pizza)
	elif not pizzeria.slice_queue.is_empty() and pizzeria.slice_queue[0].is_sliced:
		pack_up_label.text = "pack up"
		pack_up_label.modulate = Color(1, 1, 1, 1.0)
		counter_trash_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(box_texture, null)
	else:
		pack_up_label.text = "pack up"
		pack_up_label.modulate = Color(1, 1, 1, 0.3)
		counter_trash_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(box_texture, null)


func update_kitchen_station_visuals() -> void:
	var has_pizza = (pizzeria.kitchen_table_pizza != null)

	# Update prep table pizza image layers
	update_pizza_display(kitchen_pizza_texture, pizzeria.kitchen_table_pizza)

	# Make dough active only when table is empty
	make_dough_label.modulate = Color(1, 1, 1, 1.0) if not has_pizza else Color(1, 1, 1, 0.3)

	kitchen_trash_label.modulate = Color(1, 1, 1, 1.0) if has_pizza else Color(1, 1, 1, 0.3)

	var can_bake = has_pizza and pizzeria.ovens.has(null)
	into_oven_label.modulate = Color(1, 1, 1, 1.0) if can_bake else Color(1, 1, 1, 0.3)


## Updates oven progress bars: fill represents time until next stage,
## and the label explicitly counts down the time to that stage.
func update_oven_progress() -> void:
	for i in range(4):
		var p = pizzeria.ovens[i]
		var bar = oven_progress_bars[i]
		var tex_rect = oven_textures[i]
		var stage_lbl = get_or_create_stage_label(bar)

		update_pizza_display(tex_rect, p)

		if p != null:
			var t = p.cook_time
			var doneness = p.get_doneness()

			match doneness:
				Pizza.Doneness.RAW:
					# Progress filling towards UNDERCOOKED (8.0s)
					bar.value = clampf(t / Pizza.TIME_UNDERCOOKED, 0.0, 1.0)
					bar.modulate = Color(0.7, 0.7, 0.8) # Pale dough
					var remaining = maxf(0.0, Pizza.TIME_UNDERCOOKED - t)
					stage_lbl.text = "RAW (%.1fs to bake)" % remaining

				Pizza.Doneness.UNDERCOOKED:
					# Progress filling towards PERFECT (16.0s)
					var stage_duration = Pizza.TIME_PERFECT_MIN - Pizza.TIME_UNDERCOOKED
					bar.value = clampf((t - Pizza.TIME_UNDERCOOKED) / stage_duration, 0.0, 1.0)
					bar.modulate = Color(1.0, 0.75, 0.2) # Warm amber
					var remaining = maxf(0.0, Pizza.TIME_PERFECT_MIN - t)
					stage_lbl.text = "BAKING (%.1fs to PERFECT)" % remaining

				Pizza.Doneness.PERFECT:
					# Progress filling across PERFECT window towards OVERCOOKED (28.0s)
					var stage_duration = Pizza.TIME_PERFECT_MAX - Pizza.TIME_PERFECT_MIN
					bar.value = clampf((t - Pizza.TIME_PERFECT_MIN) / stage_duration, 0.0, 1.0)
					bar.modulate = Color(0.2, 0.95, 0.3) # Bright Green
					var remaining = maxf(0.0, Pizza.TIME_PERFECT_MAX - t)
					stage_lbl.text = "★ PERFECT! (%.1fs left) ★" % remaining

				Pizza.Doneness.OVERCOOKED:
					# Progress filling towards BURNT (40.0s)
					var stage_duration = Pizza.TIME_BURNT - Pizza.TIME_PERFECT_MAX
					bar.value = clampf((t - Pizza.TIME_PERFECT_MAX) / stage_duration, 0.0, 1.0)
					bar.modulate = Color(0.95, 0.4, 0.1) # Urgent red-orange
					var remaining = maxf(0.0, Pizza.TIME_BURNT - t)
					stage_lbl.text = "BURNING IN: %.1fs!" % remaining

				Pizza.Doneness.BURNT:
					bar.value = 1.0
					bar.modulate = Color(0.4, 0.1, 0.1) # Dark burnt
					stage_lbl.text = "BURNT!"
		else:
			bar.value = 0.0
			bar.modulate = Color(1, 1, 1, 0.2)
			stage_lbl.text = "EMPTY"


## Spawns a random customer order in an available slot
func spawn_random_order() -> void:
	var slot_to_fill: int = -1
	for i in range(4):
		var ord = pizzeria.order_slots[i]
		if ord == null or ord.status == Order.Status.EMPTY or ord.status == Order.Status.SERVED or ord.status == Order.Status.EXPIRED:
			slot_to_fill = i + 1
			break

	if slot_to_fill == -1:
		return

	var possible = ["SAUCE", "CHEESE", "PEPPERONI"]
	possible.shuffle()
	var count = randi_range(1, 3)
	var chosen: Array[String] = []
	for i in range(count):
		chosen.append(possible[i])

	pizzeria.spawn_order(slot_to_fill, chosen, randf_range(80.0, 110.0), randf_range(130.0, 170.0))
	refresh_ui()


# Signal callbacks
func _on_state_updated(_arg = null) -> void:
	refresh_ui()


func _on_oven_updated(_slot: int, _p: Pizza) -> void:
	refresh_ui()


func _on_order_updated(_slot: int, _o: Order) -> void:
	refresh_ui()


func _on_order_reviewed(slot: int, review: Dictionary) -> void:
	print("Order review on slot %d: %s" % [slot, review])
	refresh_ui()
