module Ade

  class Activity
    attr_reader :date, :name, :day, :begin_time, :duration, :teachers, :rooms
    
    def initialize(activity_hash)
      @date = activity_hash[:date]
      @name = activity_hash[:name]
      @day = activity_hash[:day]
      @begin_time = get_hour_mins activity_hash[:begin_time]
      @duration = get_hour_mins activity_hash[:duration]
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
    
    def end_time
      hours = @begin_time[:hours] + @duration[:hours]
      minutes = @begin_time[:minutes] + @duration[:minutes]
      hours += minutes / 60
      minutes %= 60
      { hours: hours, minutes: minutes }
    end
    
    def begin_time_in_minutes
      @begin_time[:hours] * 60 + @begin_time[:minutes]
    end
    
    def end_time_in_minutes
      begin_time_in_minutes + @duration[:hours] * 60 + @duration[:minutes]
    end
    
    private
    
    def get_hour_mins(time)
      hours, minutes = time.split 'h'
      hours = hours.to_i
      minutes = minutes.to_i
      { hours: hours, minutes: minutes }
    end
      
  end
  
end
