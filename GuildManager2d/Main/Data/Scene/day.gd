extends State

@export var time_service: Node2D 

@onready var day_timer: Timer = $DayTimer

var customer_schedule = []

var sin_offset = 0
var gaussian_middle = 8
var gaussian_width = 4

func Enter():	
	sin_offset = Global.rng.randf_range(0, PI)
	customer_schedule = create_customer_schedule(12, time_service.total_customer)
	time_service.send_customer_schedule(customer_schedule)
	day_timer.start()

func Exit():
	day_timer.stop()

func create_customer_schedule(day_range, total_customers):
	var hours_in_day = day_range
	var customers_remaining = total_customers
	var created_schedule = []

	var integral_diffision = gaussian_integral(0, hours_in_day, hours_in_day)
	for hour in range(0, hours_in_day):
		if customers_remaining > 0:
			var percentage = gaussian_disstribution(hour, gaussian_middle, gaussian_width) / integral_diffision
			var round_percentage = round(percentage * 100) / 100
			var mixed_distribution = round_percentage * sin_distribution(hour, sin_offset)
			var hourly_customers = round(mixed_distribution * total_customers)
			
			hourly_customers = min(hourly_customers, customers_remaining)
			created_schedule.append(hourly_customers)
			customers_remaining -= hourly_customers
		else:
			created_schedule.append(0)
	return customer_schedule

func sin_distribution(x, offset = 0):
	var sin_at_x = (sin(x * 10 + offset) + 2 * 2) / 2 * 0.5
	return sin_at_x
	
func gaussian_disstribution( x, high_point_pos, width):
	var a = -pow((x - high_point_pos), 2)
	var b = 2 * pow(width, 2)
	return exp(a / b)
	
func gaussian_integral(start, end, graniolarity) -> float:
	var step_size = float((end - start)) / graniolarity
	var sum = (gaussian_disstribution(start, gaussian_middle, gaussian_width) + gaussian_disstribution(end, gaussian_middle, gaussian_width)) / 2
	
	for i in range(1, graniolarity):
		var x_i = start + i * step_size
		sum += gaussian_disstribution(x_i, gaussian_middle, gaussian_width)
	return sum * step_size
	
func wait_till_change():
	print("Day timer stopped")
	day_timer.stop()
	
func _on_day_timer_timeout() -> void:
	time_service.increase_time()
	
