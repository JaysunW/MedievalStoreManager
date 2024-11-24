#extends Node
#
#class_name ItemValues
#
## Declare item properties
#var item_name: String
#var type: String
#var store_area: String
#var value: int
#var average_value: int
#
## Constructor (_init) to initialize the item properties
#func _init(item_name: String, type: String, store_area: String, value: int, average_value: int):
#	self.item_name = item_name
#	self.type = type
#	self.store_area = store_area
#	self.value = value
#	self.average_value = average_value
#
## Optionally, add a function to print or return the item details for testing
#func print_item_details():
#	print("Item Name: ", item_name)
#	print("Type: ", type)
#	print("Store Area: ", store_area)
#	print("Value: ", value)
#	print("Average Value: ", average_value)
