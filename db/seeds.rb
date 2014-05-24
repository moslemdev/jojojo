# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

puts "seeding"
surahs = nil
File.open "db/surahs.json" do |f|
	surahs = JSON.parse f.read()
end
cur = 0
surahs.each do |name, length|
	s = Surah.new
	s.name = name
	s.start =  cur
	s.memory = 0
	s.end = cur+length
	s.save
	cur += length
end
