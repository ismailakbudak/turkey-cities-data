
def clear_result_file file
	File.open(file, 'w') { |f| f.write "" }
end

def write_result_file val, file
	File.open(file, 'ab+') do |f| 
		f.write val
		f.write "\n" 
	end
end

def create_matrix field_name, matrix_json, result_file_name
	clear_result_file result_file_name
	
	from_city_ids = matrix_json.map{|x| x['from_id']}.uniq.sort
	to_city_ids = matrix_json.map{|x| x['to_id']}.uniq.sort

	max_length = 15
	(1..max_length).each do |i|
		val = "%19s" % [" "]
		to_city_ids.each do |to_id|
			city = matrix_json.select{|c| c['to_id'] == to_id}.first
			index = max_length - i + 1
			name_length = city["to_name"].length 
			if max_length - i < name_length 
				k = name_length - index
				val += "      %s  " % [ city["to_name"][k] ]	
			else	
				val += "      %s  " % [ " " ]
			end
		end
		write_result_file(val, result_file_name)  
	end 

	val = "%19s" % [" "]
	to_city_ids.each do |to_id|
		city = matrix_json.select{|c| c['to_id'] == to_id}.first
		# val += "%15s %02d" % [ city["to_name"], to_id ]
		val += "     %02d  " % [ to_id ]
	end

	write_result_file(val, result_file_name)  

	from_city_ids.each do |from_id|
		city = matrix_json.select{|c| c['from_id'] == from_id}.first

		val = "%15s %02d" % [ city["from_name"], from_id ]
		
		to_city_ids.each do |to_id|
			matrix_row_city = matrix_json.select{|x| x['from_id'] == from_id and x['to_id'] == to_id}.first
			val += "%#9d" % [ matrix_row_city[field_name].to_s ]
		end
		write_result_file(val, result_file_name)  
	end
end