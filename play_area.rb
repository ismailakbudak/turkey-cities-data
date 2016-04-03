require 'json'
require './helpers'

distance_result_file_name 	= "./data/distance_result.txt"
duration_result_file_name 	= "./data/duration_result.txt"
euclidean_result_file_name 	= "./data/euclidean_result.txt"
circuity_result_file_name 	= "./data/circuity_result.txt"

matrix_file_name 			= "./data/matrix.json"
matrix_file 				= File.read(matrix_file_name)
matrix_json 				= JSON.parse(matrix_file)	

create_matrix "distance", matrix_json, distance_result_file_name
create_matrix "duration", matrix_json, duration_result_file_name
create_matrix_for_float "euclidean_distance", matrix_json, euclidean_result_file_name
create_matrix_for_float "circuity_factor", matrix_json, circuity_result_file_name