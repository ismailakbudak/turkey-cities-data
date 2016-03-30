require 'json'
require './helpers'

distance_result_file_name 	= "./distance_result.txt"
duration_result_file_name 	= "./duration_result.txt"
matrix_file_name 			= "./data/matrix.json"
matrix_file 				= File.read(matrix_file_name)
matrix_json 				= JSON.parse(matrix_file)	

create_matrix "distance", matrix_json, distance_result_file_name
create_matrix "duration", matrix_json, duration_result_file_name