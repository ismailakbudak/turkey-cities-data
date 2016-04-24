require 'json'
require 'google_maps_service'
require './config/secrets'
require 'fileutils'

def find locations_json, path_directory, parameter
	gmaps 		= GoogleMapsService::Client.new(key: Config::SECRETS[:google_api_key] )
	locations	= JSON.parse(File.read(locations_json))

	unless File.directory?(path_directory)
		FileUtils.mkdir_p(path_directory)
	end 
	locations.each do |location|

		root = "#{path_directory}/#{location['id']}"
		Dir.mkdir root

		locations.select{|i| i['id'] > location['id'] }.each do |location_in|
			first 	= "#{location['lattitude']},#{location['longitude']}"
			second 	= "#{location_in['lattitude']},#{location_in['longitude']}"

			routes = gmaps.directions( first, second, mode: 'driving', alternatives: false)

			File.open("#{root}/#{parameter}-#{location['id']}-#{location_in['id']}.json", 'ab+') do |f|
				f.write JSON.pretty_generate(routes)
			end

			File.open("#{root}/#{parameter}-#{location_in['id']}-#{location['id']}.json", 'ab+') do |f|
				f.write JSON.pretty_generate(routes)
			end
			puts '.'
		end
	end
end

if __FILE__ == $0
	if ARGV.length == 1
		file_json = "./data/#{ARGV[0]}.json"
		path_directory = "./data/#{ARGV[0]}"
		find file_json, path_directory, ARGV[0]
	else
		puts 'You should enter json file name existing in data directory'
	end
end