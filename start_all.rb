require './set_location_id'
require './get_locations_distances'
require './create_distance_duration_matrix_json'
require './calculate_euclidean_distance_matrix'
require './calculate_circuity_factor_matrix'
require './write_results'

if __FILE__ == $0
  if ARGV.length == 1
    parameter                 = ARGV[0]
    locations_json            = "./data/#{parameter}.json"
    locations_dd_matrix_json  = "./data/#{parameter}-dd-matrix.json"
    path_directory            = "./data/#{parameter}"

    set_location_id locations_json
    get_locations_distances locations_json, path_directory, parameter
    create_distance_duration_matrix_json locations_json, locations_dd_matrix_json, path_directory, parameter
    calculate_euclidean_distance_matrix locations_json, locations_dd_matrix_json
    calculate_circuity_factor_matrix locations_dd_matrix_json
    write_results parameter
  else
    puts 'You should enter file name existing in data directory'
  end
end