#!/usr/bin/env ruby

require_relative 'interactive_reader.rb'
require_relative 'config.rb'
require_relative 'activity.rb'
require_relative 'schools/ujf.rb'

r = Ade::InteractiveReader.new Ade::Schools::Ujf.new
r.debug_mode = true

while not r.logged_in?
  puts "login:"
  login = gets.strip

  puts "password:"
  password = gets.strip

  puts "cas domain (opt.):"
  domain = gets.strip
  domain = nil if domain.empty?

  puts "* logging in..."
  r.login login, password, domain
  
  puts "!!! try again:" unless r.logged_in?
end

puts "* looking for projects..."
projects = r.projects

unless projects.empty?
  i = 1
  projects.each do |project|
    puts "#{i}. #{project[:name]}"
    i += 1
  end

  puts "project number:"
  project_number = gets.to_i - 1
  project = projects[project_number]

  puts "* opening project #{project[:name]}..."
  r.project = project
end

puts "* looking for categories..."
categories = r.categories
i = 1
categories.each do |category|
  puts "#{i}. #{category[:name]}"
  i += 1
end

puts "category number:"
category_number = gets.to_i - 1
category = categories[category_number]

puts "* opening category #{category[:name]}..."
r.category = category

while not r.leaf?
  puts "* looking for branches..."
  branches = r.branches
  i = 1
  branches.each do |branch|
    puts "#{i}. #{branch[:name]}"
    i += 1
  end

  puts "branch number:"
  branch_number = gets.to_i - 1
  branch = branches[branch_number]

  puts "* opening branch #{branch[:name]}..."
  r.branch = branch
end

puts "* setting up ade table view options"
r.setup_table_view_options

puts "* looking for ade week number"
r.find_current_week

puts "choose agenda view:"
puts "1. Full"
puts "2. Week"
puts "3. Day"
agenda_view = gets.strip

case agenda_view
when '1'
  agenda = r.full_agenda
when '2'
  agenda = r.week_agenda
else #3
  agenda = r.day_agenda
end

agenda.each do |activity|
  puts activity
  puts
end


