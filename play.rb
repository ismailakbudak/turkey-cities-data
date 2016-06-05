require 'spreadsheet'
require 'json'
require './helpers'
require 'turkish_support'

using TurkishSupport

file_name = './data/excels/il.xls'
yml_file = './data/turkey-towns.yml'
cities_json = './data/turkey-cities.json'
cities = JSON.parse(File.read(cities_json))

population = Spreadsheet.open(file_name) 
sheet1 = population.worksheet('Sheet1') # can use an index or worksheet name

sheet1.each do |row| 
	city_name = row[0]
	town = row[1]
  city = cities.select{|c| c['name'].downcase.include? city_name.downcase }.first
  if city.nil? 
    puts city_name
  else
    #puts city['id']
  end 
  val = "#{town.capitalize}, #{city_name.capitalize}, Türkiye"
  write_result_file(val, yml_file)
end