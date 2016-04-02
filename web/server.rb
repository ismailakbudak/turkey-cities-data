require 'webrick'
require 'json'

# default port to 3000 or overwrite with PORT variable by running
# $ PORT=3001 ruby server.rb
port = ENV['PORT'] ? ENV['PORT'].to_i : 3000

puts "Server started: http://localhost:#{port}/"

root = File.expand_path './public'
server = WEBrick::HTTPServer.new Port: port, DocumentRoot: root

trap('INT') { server.shutdown }

server.start
