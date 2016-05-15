require 'spreadsheet'
require 'json'

def name_include(location, location_name)
  name = location['name'].split(',')[0].strip
  location_name.include? name
end

def set_location_population excel_file, json_file
  locations = JSON.parse(File.read(json_file))

  population = Spreadsheet.open(excel_file)
  sheet0 = population.worksheet('Sheet0') # can use an index or worksheet name
  sheet1 = population.worksheet('Sheet2') # can use an index or worksheet name

  location_names = sheet0.first
  names = location_names.each_with_index.select{|column, key| key >= 3 }
  sheet0.each do |row|
    next if row[0].nil? # if first cell empty
    gender 			= row[1]
    year 				= row[2]
    numbers 		= row.each_with_index.select{|column, key| key >= 3 }
    numbers.length.times do |index|

      number 				= numbers[index][0]
      location_name = names[index][0]
      location 			= locations.select{|c| name_include(c, location_name) }.first
      if location.nil?
        puts location_name
      else
        if location['populations'].nil?
          location['populations'] = []
        end
        population = location['populations'].select{|c| c[:year] == year.to_s or c['year'] ==  year.to_s}.first
        if population.nil?
          population = {
              'year': year
          }
          location['populations'].push(population)
        end
        population[gender] = number
      end
    end
  end

  location_names 	= sheet1.first
  names 					= location_names.each_with_index.select{|column, key| key >= 3 }

  sheet1.each do |row|
    next if row[0].nil? # if first cell empty
    year 			= row[2]
    numbers 	= row.each_with_index.select{|column, key| key >= 3 }
    total 		= numbers.last[0]
    numbers.length.times do |index|
      number 				= numbers[index][0]
      location_name = names[index][0]
      location 			= locations.select{|c| name_include(c, location_name) }.first
      if location.nil?
        puts location_name.inspect
      else
        population = location['populations'].select{|c| c[:year] ==  year.to_s or c['year'] ==  year.to_s }.first
        if population.nil?
          puts location['name']
        else
          population['total_in_town'] = number
          population['rate_over_total'] = (number.to_f / total.to_f) * 100
        end
      end
    end
  end

  # File.open(json_file, 'w') do |f|
  #   f.write JSON.pretty_generate(locations)
  # end
end

if __FILE__ == $0
  if ARGV.length == 1
    json_file = './data/aegean-towns.json'
    excel_file = "./data/excels/#{ARGV[0]}.xls"
    set_location_population excel_file, json_file
  else
    puts 'You should enter json file name existing in data directory'
  end
end