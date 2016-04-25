require 'json'
require './helpers'

def location_name(location)
  "#{get_name(location, 'from_name')} -> #{get_name(location, 'to_name')}"
end

def filtered_locations(field_name, locations)
  locations.select { |c| c[field_name] != 0 }
  # locations
end

def write_min_field(locations, field_name)
  location = filtered_locations(field_name, locations).min_by { |b| b[field_name] }
  value = "\n"
  value += "Min #{field_name}"
  value += "\n"
  value += location_name(location)
  value += "\n"
  "#{value}#{field_name.capitalize}: #{location[field_name]}"
end

def write_max_field(locations, field_name)
  location = filtered_locations(field_name, locations).max_by { |b| b[field_name] }
  value = "\n"
  value += "Max #{field_name}"
  value += "\n"
  value += location_name(location)
  value += "\n"
  "#{value}#{field_name.capitalize}: #{location[field_name]}"
end

def write_average_field(locations, field_name)
  avg = filtered_locations(field_name, locations).inject(0.0) { |sum, location| sum + location[field_name] } / locations.size
  value = "\n"
  value += "Average #{field_name}"
  value += "\n"
  "#{value}#{avg}"
end

def write_median_field(locations, field_name)
  sorted = filtered_locations(field_name, locations).sort_by { |b| b[field_name] }
  len = sorted.length
  median = (sorted[(len - 1) / 2][field_name] + sorted[len / 2][field_name]) / 2.0

  value = "\n"
  value += "Median #{field_name}"
  value += "\n"
  "#{value}#{median}"
end

def write_mode_field(locations, field_name)
  freq = filtered_locations(field_name, locations).inject(Hash.new(0)) { |h,v| h[v[field_name]] += 1; h }
  max_mode = freq.max_by { |k,v| v }
  mode = freq.map{|k,v| v}.sort.reverse.join(', ')

  value = "\n"
  value += "Mode #{field_name}"
  value += "\n"
  value += "#{mode}"
  value += "\n"
  value += "Mode max #{field_name}"
  value += "\n"
  "#{value}#{max_mode[0]}"

end

def find_freak_data(matrix_json, result_file, parameter)

  clear_result_file result_file

  locations = JSON.parse(File.read(matrix_json))
  value = "Information for #{parameter}"
  value += "\n----------------------------------\n"
  value += write_max_field(locations, 'distance')
  value += write_max_field(locations, 'duration')
  value += write_max_field(locations, 'euclidean_distance')
  value += write_max_field(locations, 'circuity_factor')
  value += "\n"
  value += write_min_field(locations, 'distance')
  value += write_min_field(locations, 'duration')
  value += write_min_field(locations, 'euclidean_distance')
  value += write_min_field(locations, 'circuity_factor')
  value += "\n"
  value += write_average_field(locations, 'distance')
  value += write_average_field(locations, 'duration')
  value += write_average_field(locations, 'euclidean_distance')
  value += write_average_field(locations, 'circuity_factor')
  value += "\n"
  value += write_median_field(locations, 'distance')
  value += write_median_field(locations, 'duration')
  value += write_median_field(locations, 'euclidean_distance')
  value += write_median_field(locations, 'circuity_factor')
  value += "\n"
  value += write_mode_field(locations, 'distance')
  value += write_mode_field(locations, 'duration')
  value += write_mode_field(locations, 'euclidean_distance')
  value += write_mode_field(locations, 'circuity_factor')
  value += "\n"


  write_result_file(value, result_file)
end

if __FILE__ == $0
  if ARGV.length == 1
    matrix_json = "./data/#{ARGV[0]}-dd-matrix.json"
    result_file = "./result/#{ARGV[0]}/general.txt"
    find_freak_data matrix_json, result_file, ARGV[0]
  else
    puts 'You should enter json file name existing in data directory'
  end
end