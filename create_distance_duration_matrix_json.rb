require 'json'

def calculate(locations_json, matrix_json, path_directory, parameter)

	locations = JSON.parse(File.read(locations_json))
	matrix = []
	locations.each do |location|

		root 	= "#{path_directory}/#{location['id']}"
		val 	= {'from_name': location['name'], 'to_name': location['name'], 'from_id': location['id'], 'to_id': location['id'], 'distance': 0, 'duration': 0 }
		matrix << val

		locations.select{|i| i['id'] > location['id'] }.each do |location_in|

			file_name = "#{root}/#{parameter}-#{location['id']}-#{location_in['id']}.json"
			routes 		= JSON.parse(File.read(file_name))

			puts distance = routes[0]['legs'][0]['distance']['value']
			puts duration = routes[0]['legs'][0]['duration']['value']

			val = {'from_name': location['name'], 'to_name': location_in['name'], 'from_id': location['id'], 'to_id': location_in['id'], 'distance': distance, 'duration': duration }
			matrix << val

			val = {'from_name': location_in['name'], 'to_name': location['name'], 'from_id': location_in['id'], 'to_id': location['id'], 'distance': distance, 'duration': duration }
			matrix << val

			puts '.'
		end
	end

	File.open(matrix_json, 'ab+') do |f|
		f.write JSON.pretty_generate(matrix)
	end
end

if __FILE__ == $0
	if ARGV.length == 1
		locations_json 	= "./data/#{ARGV[0]}.json"
		matrix_json 		= "./data/#{ARGV[0]}-dd-matrix.json"
		path_directory 	= "./data/#{ARGV[0]}"
		calculate locations_json, matrix_json, path_directory, ARGV[0]
	else
		puts 'You should enter json file name existing in data directory'
	end
end