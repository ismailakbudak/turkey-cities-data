
def clear_result_file(file)
	File.open(file, 'w') { |f| f.write '' }
end

def write_result_file(val, file)
	File.open(file, 'ab+') do |f|
		f.write val
		f.write "\n"
	end
end

def create_matrix(field_name, matrix_json, result_file_name)
	clear_result_file result_file_name

	from_city_ids = matrix_json.map { |x| x['from_id'] }.uniq.sort
	to_city_ids = matrix_json.map { |x| x['to_id'] }.uniq.sort

	max_length 			= get_max_name_length(matrix_json, 'to_name')
	number_distance = get_max_id_length(matrix_json, 'to_id')
	value_length    = 9
	blank_distance 	= max_length + number_distance + 1
	(1..max_length).each do |i|
		val = "%#{blank_distance}s" % [' ']
		to_city_ids.each do |to_id|
			city 				= matrix_json.select { |c| c['to_id'] == to_id }.first
			index 			= max_length - i + 1
			name 				= get_name(city, 'to_name')
			name_length = name.length
			if max_length - i < name_length
				k = name_length - index
				val += "%#{value_length - 1}s%s" % [' ', name[k]]
			else
				val += "%#{value_length}s" % [' ']
			end
		end
		write_result_file(val, result_file_name)
	end

	val = "%#{blank_distance}s" % [' ']
	to_city_ids.each do |to_id|
		val += "%#{value_length - number_distance}s%0#{number_distance}d" % [' ', to_id]
	end

	write_result_file(val, result_file_name)

	# max_length = get_max_name_length(matrix_json, 'from_name')
	from_city_ids.each do |from_id|
		city = matrix_json.select { |c| c['from_id'] == from_id }.first

		val = "%#{max_length}s %0#{number_distance}d" % [get_name(city, 'from_name'), from_id]

		to_city_ids.each do |to_id|
			matrix_row_city = matrix_json.select { |x| x['from_id'] == from_id and x['to_id'] == to_id }.first
			val += "%##{value_length}d" % [matrix_row_city[field_name].to_s]
		end
		write_result_file(val, result_file_name)
	end
end

def create_matrix_for_float(field_name, matrix_json, result_file_name)
	clear_result_file result_file_name

	from_city_ids = matrix_json.map { |x| x['from_id'] }.uniq.sort
	to_city_ids = matrix_json.map { |x| x['to_id'] }.uniq.sort

	max_length 			= get_max_name_length(matrix_json, 'to_name')
	number_distance = get_max_id_length(matrix_json, 'to_id')
	value_length    = 13
	blank_distance 	= max_length + number_distance + 1
	(1..max_length).each do |i|
		val = "%#{blank_distance}s" % [' ']
		to_city_ids.each do |to_id|
			city 				= matrix_json.select { |c| c['to_id'] == to_id }.first
			index 			= max_length - i + 1
			name 				= get_name(city, 'to_name')
			name_length = name.length
			if max_length - i < name_length
				k = name_length - index
				val += "%#{value_length - 1}s%s" % [' ', name[k]]
			else
				val += "%#{value_length}s" % [' ']
			end
		end
		write_result_file(val, result_file_name)
	end

	val = "%#{blank_distance}s" % [' ']
	to_city_ids.each do |to_id|
		val += "%#{value_length - number_distance}s%0#{number_distance}d" % [' ', to_id]
	end

	write_result_file(val, result_file_name)

	from_city_ids.each do |from_id|
		city = matrix_json.select { |c| c['from_id'] == from_id }.first

		val = "%#{max_length}s %0#{number_distance}d" % [get_name(city, 'from_name'), from_id]

		to_city_ids.each do |to_id|
			matrix_row_city = matrix_json.select { |x| x['from_id'] == from_id and x['to_id'] == to_id }.first
			val += "%##{value_length}s" % [('%.3f' % matrix_row_city[field_name]).to_s]
		end
		write_result_file(val, result_file_name)
	end
end

def create_coordination(locations_json, result_file_name)
	clear_result_file result_file_name
	max_name 				= get_max_name_length(locations_json)
	number_distance = get_max_id_length(locations_json)
	val  = "%#{max_name}s  " % ['Şehir']
	val += '%14s' % ['X(Enlem)']
	val += '%14s' % ['Y(Boylam)']
	write_result_file(val, result_file_name)

	locations_json.each do |city|
		val = "%#{max_name}s %0#{number_distance}d" % [ get_name(city), city['id'] ]
		val += '%#13s' % [( '%.7f' % city['lattitude']).to_s ]
		val += '%#13s' % [( '%.7f' % city['longitude']).to_s ]
		write_result_file(val, result_file_name)
	end

end

def get_max_name_length(locations_json, field_name = 'name')
	location = locations_json.max_by{|b| b[field_name].length }
	get_name(location, field_name).length + 1
end

def get_max_id_length(locations_json, field_name = 'id')
	location = locations_json.max_by{|b| b[field_name].to_s.length }
	location[field_name].to_s.length
end

def get_name(location, field_name = 'name')
	arr = location[field_name].split(',')
	arr[0] + arr[1]
end