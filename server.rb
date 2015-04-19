require 'socket'

server = TCPServer.new('localhost', 2345)
puts "Starting server - listening on port 2345..."

# Loop forever and handle one request at a time
loop do
  # Open new socket with new request
  socket = server.accept

  # Read the request
  request = socket.gets

  # Write out requst for logging
  STDERR.puts request

  # Let's split up the request into parts
  request_pieces = request.split(" ")
  verb = request_pieces[0]
  filename = request_pieces[1]

  # Add conditions to return stuff dependent on request
  if filename == "/"
    response = "Hello World!\n"
  elsif filename == "/index.html"
    response = File.read('./index.html')
  else
    response = "Not Found\n"
  end

  # Print the required HTTP headers back so the client understands response
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"

  # Print out the actual response to the socket
  socket.print response

  # We are done handling the request - close the socket
  socket.close
end