module Ade

  class Time
    attr_reader :hours, :minutes
    
    def initialize(time_hash)
      @hours = 0
      @minutes = 0
      if time_hash[:string]
        @hours, @minutes = time_hash[:string].split('h').map!{|num| num.to_i }
        @minutes = 0 if @minutes.nil?
      else
        @hours = time_hash[:hours].to_i if time_hash[:hours]
        @minutes = time_hash[:minutes].to_i if time_hash[:minutes]
      end
    end
    
    def to_s
      hours = @hours
      minutes = @minutes
      hours = "0#{hours}" if hours < 10
      minutes = "0#{minutes}" if minutes < 10
      "#{hours}h#{minutes}"
    end
    
    def readable_duration
      hours = @hours
      minutes = @minutes
      if hours > 0 && minutes > 0
        "#{hours} heure#{hours > 1 ? 's' : ''} et #{minutes} minute#{minutes > 1 ? 's' : ''}"
      elsif hours > 0
        "#{hours} heure#{hours > 1 ? 's' : ''}"
      else
        "#{minutes} minute#{minutes > 1 ? 's' : ''}"
      end
    end
    
    def total_minutes
      @hours * 60 + @minutes
    end
    
    def +(other)
      total_mins = self.total_minutes + other.total_minutes
      hours = total_mins / 60
      minutes = total_mins % 60
      Time.new hours: hours, minutes: minutes
    end
    
    def -(other)
      total_mins = self.total_minutes - other.total_minutes
      hours = total_mins / 60
      minutes = total_mins % 60
      Time.new hours: hours, minutes: minutes
    end
      
  end
  
end
