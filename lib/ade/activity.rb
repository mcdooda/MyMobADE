module Ade

  class Activity
    attr_reader :date, :name, :day, :hour, :duration, :teachers, :rooms
    
    def initialize(activity_hash)
      @date = activity_hash[:date]
      @name = activity_hash[:name]
      @day = activity_hash[:day]
      @hour = activity_hash[:hour]
      @duration = activity_hash[:duration]
      @teachers = activity_hash[:teachers]
      @rooms = activity_hash[:rooms]
    end
    
    def to_s
      "date: #{@date}\n" +
      "name: #{@name}\n" +
      "day: #{@day}\n" +
      "hour: #{@hour}\n" +
      "duration: #{@duration}\n" +
      "teachers: #{@teachers}\n" +
      "rooms: #{@rooms}\n"
    end
    
  end
  
end
