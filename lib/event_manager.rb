require "csv"
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_number(phone_number)
	phone_number = phone_number.to_s.gsub(/[^\d]/, "").ljust(10, "0")
	if phone_number.length > 10 and phone_number[0] == "1"
		phone_number = phone_number[1..10]
	else
		phone_number
	end
end

def register_date(register_date)
	register_date = DateTime.strptime(register_date, '%m/%d/%Y %H:%M')
end

def popular_hour(hour_array)
	hour_array.max_by {|i| hour_array.count(i)}
end

def popular_day(day_array)
	popular_day = day_array.max_by {|i| day_array.count(i)}
	to_string = {0 => "Sunday", 1 => "Monday", 2 => "Tuesday", 3 => "Wednesday", 4 => "Thursday", 5 => "Friday", 6 => "Saturday"}
	to_string[popular_day]
end

def legislators_by_zipcode(zipcode)
	civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
	civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

	begin
		civic_info.representative_info_by_address(
			address: zipcode,
			levels: 'country',
			roles: ['legislatorUpperBody', 'legislatorLowerBody']
		).officials
	rescue
		"You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
	end
end

def save_thank_you_letter(id,form_letter)
	Dir.mkdir("output") unless Dir.exists?("output")

	filename = "output/thanks_#{id}.html"

	File.open(filename,'w') do |file|
		file.puts form_letter
	end
end

puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter
#hour_array = Array.new
day_array = Array.new

contents.each do |row|
	id = row[0]
	name = row[:first_name]
	zipcode = clean_zipcode(row[:zipcode])
	legislators = legislators_by_zipcode(zipcode)
	phone_number = clean_phone_number(row[:homephone])
	register_date = register_date(row[:regdate])
	register_hour = register_date.hour
	register_day = register_date.wday
	#hour_array.push(register_hour)
	day_array.push(register_day)

	#form_letter = erb_template.result(binding)
	
	#save_thank_you_letter(id,form_letter)

	#puts "#{name} #{register_day}"
end

#puts "The most popular hour is #{popular_hour(hour_array)}."

puts "The most popular day is #{popular_day(day_array)}."
