puts "EventManager Initialized!"

=begin
contents = File.read "event_attendees.csv"
puts contents
=end

lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index|
	next if index == 0
	columns = line.split(",")
	name = columns[2]
	puts name
end
