require 'spreadsheet'
require 'json'

file_name = './data/excels/turkey-cities.xls'
cities_json = './data/turkey-cities.json'

file = File.read(cities_json)
cities = JSON.parse(file)


population = Spreadsheet.open(file_name)
sheet0 = population.worksheet('Sheet0') # can use an index or worksheet name
sheet1 = population.worksheet('Sheet2') # can use an index or worksheet name

city_names = sheet0.first
names = city_names.each_with_index.select{|column, key| key >= 3 }

sheet0.each do |row| 
  	next if row[0].nil? # if first cell empty 
  	gender 			= row[1]
  	year 			= row[2]
  	numbers 		= row.each_with_index.select{|column, key| key >= 3 }
  	numbers.length.times do |index|

  		number = numbers[index][0]
  		city_name = names[index][0]

  		city_name = city_name.split('-')[0] 
		city = cities.select{|c| c['name'].include?  city_name }.first
	  	if city.nil?
	  		puts city_name
	  	else		
			if city['populations'].nil?
	  			city['populations'] = []
	  		end
  			population = city['populations'].select{|c| c[:year] == year.to_s or c['year'] ==  year.to_s }.first
  			if population.nil?
  				population = {
							'year': year
				}
  				city['populations'].push(population)
  			end
  			population[gender] = number
	  	end
  	end
end


city_names = sheet1.first
names = city_names.each_with_index.select{|column, key| key >= 3 }

sheet1.each do |row| 
  	next if row[0].nil? # if first cell empty
  	year 			= row[2]
  	numbers 		= row.each_with_index.select{|column, key| key >= 3 }
	total 			= numbers.last[0]		
  	numbers.length.times do |index|
  		number = numbers[index][0]
  		city_name = names[index][0]
  		city_name = city_name.split('-')[0] 
		city = cities.select{|c| c['name'].include?  city_name }.first
	  	if city.nil?
	  		puts city_name.inspect
	  	else
  			population = city['populations'].select{|c| c[:year] == year.to_s or c['year'] ==  year.to_s }.first
  			if population.nil?
  				puts city['name']
  			else
  				population['total_in_city'] = number
  				population['rate_over_total'] = (number.to_f / total.to_f) * 100
  			end
	  	end
  	end
end

File.open(cities_json, 'w') do |f|
	f.write JSON.pretty_generate(cities)
end
