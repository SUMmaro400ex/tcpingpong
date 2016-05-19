require "socket"

#Listening on localhost port 9000
#Bind to port 9000
server = TCPServer.new 9000

#
loop do
  puts "Listening for connection"
  # Wait for a client to connect
  # Accept returns an instance of a socket object, it is an idle object
  client = server.accept
  # get the first line of text the client sent
  # puts client.gets
  while line = client.gets
    puts line
    break if line == "\r\n"
  end

  # Write back
  client.puts "Pong"
  # Close the socket so the client stops waiting
  client.close
end