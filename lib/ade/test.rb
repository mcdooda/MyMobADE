#!/usr/bin/env ruby

require_relative 'reader.rb'
require_relative 'config.rb'
require_relative 'activity.rb'
require_relative 'schools/ujf.rb'
require_relative 'schools/imag.rb'
require_relative 'schools/classes/l3infog2.rb'

r = Ade::Reader.new Ade::Schools::Classes::L3infog2.new
r.login
r.select_project
r.select_category
r.select_branch
r.select_table_view_options
r.get_full_agenda.each do |activity|
  puts activity
  puts
end
