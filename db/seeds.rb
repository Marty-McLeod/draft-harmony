# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

  # Faker::Address.street_address
  # Faker::PhoneNumber.phone_number_with_country_code
  # Faker::Book.title
  # Faker::Lorem.paragraphs(nubmer: x) *as array
  # Faker::Lorem.sentence(word_count: x)
  # Faker::LoremFlickr.image

require "faker"



puts "Deleting #{Task.count} existing Task records.."
if Task.count > 0
  tasks = Task.all
  tasks.destroy_all
end

puts "==" * 20
puts "Deleting user(s): count #{User.count}"
puts User.destroy_all
puts "--" * 20

puts "Verify: #{Task.count} found now. #{User.count} users found now."

puts "==" * 20
puts "Create new User:"
user = User.create!(email: "johnsmith@yahoo.com", password: "abbadabba123")
puts "User: #{user.email}, pwd: #{user.password}"
puts "--" * 20
puts "Creating dummy writing tasks.."

num = 6

num.times do |index|
  puts "Creating record ##{index + 1}.., index #{index}"
  task = Task.new()
  task.user_id = user.id
  task.title = Faker::Book.title
  task.synopsis = Faker::Lorem.sentence(word_count: 26)
  if task.save!
    puts "ID #{index} saved"
  end
  # Add a note to each record with dummy text
  task.notes.create(text: Faker::Lorem.sentence(word_count: 20))

  # Adds an outline except for the last
  if (0...num - 2).include?(index)
    puts "-- Creating outline for Task ##{index + 1}"
    task.create_outline(contents: Faker::Lorem.paragraphs(number: 4).join(''))
  end
end

# Display all records to verify
tasks = Task.all

puts "--" * 20 
puts "Verifying:"
puts "--" * 20

tasks.each_with_index do |task|
  puts "ID:#{task.id}, title: #{task.title}"
  puts "Syn: #{task.synopsis}"
  puts "Notes: #{task.notes.first.text}"
  puts "Outline:  #{task.outline.present? ? 'Yes' : 'NO'}"
end
puts "--" * 20
puts "Total records: #{Task.count}"