require "csv"
puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
	name = row[:first_name]
	zipcode = row[:zipcode]

	#if the zip code is exactly five digits, assume it is ok
	#if the zip code is more than five digits, truncate it to the first five digits
	#if the zip code is less than five digits, and zeros to front until it is five digits

	if zipcode.nil?
		zipcode = "00000"
	elsif zipcode.length < 5
		zipcode = zipcode.rjust 5, "0"
	elsif zipcode.length > 5
		zipcode = zipcode[0..4]
	end

	puts "#{name} #{zipcode}"
end
