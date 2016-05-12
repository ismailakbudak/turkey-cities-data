require 'json'

def calculate_circuity_factor_matrix(matrix_json)
	matrix = JSON.parse(File.read(matrix_json))

	matrix.each do |value|
		# Convert meter distance to kilometer
		distance = value['distance'].to_f / 1000
		euclidean_distance = value['euclidean_distance'].to_f
		if distance == 0
			circuity_factor = 0
		else
			circuity_factor = distance / euclidean_distance
		end
		value['circuity_factor'] = circuity_factor
	end

	File.open(matrix_json, 'w') do |f|
		f.write JSON.pretty_generate(matrix)
	end
end

if __FILE__ == $0
	if ARGV.length == 1
		locations_dd_matrix_json = "./data/#{ARGV[0]}-dd-matrix.json"
		calculate_circuity_factor_matrix locations_dd_matrix_json
	else
		puts 'You should enter json file name existing in data directory'
	end
end