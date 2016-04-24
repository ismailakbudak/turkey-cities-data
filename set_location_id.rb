require 'json'

def set_id file_json

  locations = JSON.parse(File.read(file_json))
  id = 1
  locations.each do |location|
    location['id'] 	= id
    id += 1
  end

  File.open(file_json, 'w') do |f|
    f.write JSON.pretty_generate(locations)
  end
end

if __FILE__ == $0
  if ARGV.length == 1
    file_json = "./data/#{ARGV[0]}.json"
    set_id file_json
  else
    puts 'You should enter json file name existing in data directory'
  end
end