require 'json'

def calculate(locations_json, locations_dd_matrix_json)
	locations = JSON.parse(File.read(locations_json))
	matrix 		= JSON.parse(File.read(locations_dd_matrix_json))

	matrix.each do |value|
		from 	= locations.select{|i| i['id'] == value['from_id'] }.first
		to 		= locations.select{|i| i['id'] == value['to_id'] }.first
		if from.nil? or to.nil?
			puts value.inspect
		else
			x = (from['lattitude'].to_f - to['lattitude'].to_f) ** 2
			y = (from['longitude'].to_f - to['longitude'].to_f) ** 2
			euclidean_distance = Math.sqrt( x + y )
			value['euclidean_distance'] = euclidean_distance
		end
	end

	File.open(locations_dd_matrix_json, 'w') do |f|
		f.write JSON.pretty_generate(matrix)
	end
end

if __FILE__ == $0
	if ARGV.length == 1
		locations_json = "./data/#{ARGV[0]}.json"
		locations_dd_matrix_json = "./data/#{ARGV[0]}-dd-matrix.json"
		calculate locations_json, locations_dd_matrix_json
	else
		puts 'You should enter yml file name existing in data directory'
	end
end