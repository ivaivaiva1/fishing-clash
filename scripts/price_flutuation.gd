extends Node
class_name PriceFlutuation

var market_multiplier: float
var actual_price: float

var trend: float = 1.0 # 1 = sobe, -1 = desce
var trend_strength: float = 0.1
var volatility: float = 0.1

var update_cooldown: float = 0.1
var update_timer: float = 0.0

var open_market: bool = false

@onready var priceLabel: Label = %"price label"

func _ready():
	randomize()
	#open_market_func()

func _process(delta):
	if not open_market:
		return
	
	update_timer += delta
	
	if update_timer < update_cooldown:
		return
	
	update_timer = 0.0
	
	if randf() < 0.01:
		trend *= -1
	
	var change = trend * trend_strength + randf_range(-volatility, volatility)
	market_multiplier += change * update_cooldown
	market_multiplier = clamp(market_multiplier, 0.95, 2.05)

	if market_multiplier <= 1.0:
		trend = 1.0
	elif market_multiplier >= 2.0:
		trend = -1.0
	
	update_actual_price()


func update_actual_price():
	actual_price = snapped(market_multiplier, 0.1)
	priceLabel.text = "$%.1f" % actual_price


# 🔓 Abre o mercado
func open_market_func():
	open_market = true
	update_timer = 0.0
	
	market_multiplier = randf_range(1.0, 2.0)
	trend = 1.0 if randf() < 0.5 else -1.0
	
	update_actual_price()


# 🔒 Fecha o mercado
func close_market_func():
	open_market = false
