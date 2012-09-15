module Ade

  class Activity
    attr_reader :date, :name, :day, :begin_time, :duration, :teachers, :rooms
    
    def initialize(activity_hash)
      @date = activity_hash[:date]
      @name = activity_hash[:name]
      @day = activity_hash[:day]
      @begin_time = Ade::Time.new string: activity_hash[:begin_time]
      @duration = Ade::Time.new string: activity_hash[:duration]
      @teachers = activity_hash[:teachers]
      @rooms = activity_hash[:rooms]
    end
    
    def to_s
      "date: #{@date}\n" +
      "name: #{@name}\n" +
      "day: #{@day}\n" +
      "begin time: #{@begin_time}\n" +
      "duration: #{@duration}\n" +
      "teachers: #{@teachers}\n" +
      "rooms: #{@rooms}\n"
    end
    
    def end_time
      @begin_time + @duration
    end
      
  end
  
end
