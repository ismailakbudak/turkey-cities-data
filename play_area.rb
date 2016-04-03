require 'json'
require './helpers'

distance_result_file_name 			= "./data/distance_result.txt"
duration_result_file_name 			= "./data/duration_result.txt"
euclidean_result_file_name 			= "./data/euclidean_result.txt"
circuity_result_file_name 			= "./data/circuity_result.txt"
cities_cordination_result_file_name	= "./data/cities_cordination_result.txt"

matrix_file_name 			= "./data/matrix.json"
cities_file_name 			= "./data/cities.json"
matrix_json 				= JSON.parse(File.read(matrix_file_name))	
cities_json 				= JSON.parse(File.read(cities_file_name))	

create_matrix "distance", matrix_json, distance_result_file_name
create_matrix "duration", matrix_json, duration_result_file_name
create_matrix_for_float "euclidean_distance", matrix_json, euclidean_result_file_name
create_matrix_for_float "circuity_factor", matrix_json, circuity_result_file_name
create_coorditanion cities_json, cities_cordination_result_file_name