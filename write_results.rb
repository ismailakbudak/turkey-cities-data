require 'json'
require './helpers'
require 'fileutils'

def write_results(parameter)
  root = "./result/#{parameter}"
  unless File.directory?(root)
    FileUtils.mkdir_p(root)
  end

  distance_result_file_name 	  = "#{root}/distance.txt"
  duration_result_file_name 		= "#{root}/duration.txt"
  euclidean_result_file_name 		= "#{root}/euclidean.txt"
  circuity_result_file_name 		= "#{root}/circuity.txt"
  coordination_result_file_name	= "#{root}/coordination.txt"
  matrix_file_name 			        = "./data/#{parameter}-dd-matrix.json"
  cities_file_name 			        = "./data/#{parameter}.json"

  matrix_json 				= JSON.parse(File.read(matrix_file_name))
  cities_json 				= JSON.parse(File.read(cities_file_name))

  create_matrix 'distance', matrix_json, distance_result_file_name
  create_matrix 'duration', matrix_json, duration_result_file_name
  create_matrix_for_float 'euclidean_distance', matrix_json, euclidean_result_file_name
  create_matrix_for_float 'circuity_factor', matrix_json, circuity_result_file_name
  create_coordination cities_json, coordination_result_file_name
end

if __FILE__ == $0
  if ARGV.length == 1
    write_results ARGV[0]
  else
    puts 'You should enter json file name existing in data directory'
  end
end