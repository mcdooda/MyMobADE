module AgendaHelper
  
  def readable_time(time)
    hours = time[:hours]
    minutes = time[:minutes]
    hours = "0#{hours}" if hours < 10
    minutes = "0#{minutes}" if minutes < 10
    "#{hours}h#{minutes}"
  end
  
  def readable_duration(duration)
    hours = duration / 60
    minutes = duration % 60
    if hours > 0 && minutes > 0
      "#{pluralize hours, 'heure'} et #{pluralize minutes, 'minute'}"
    elsif hours > 0
      "#{pluralize hours, 'heure'}"
    else
      "#{pluralize minutes, 'minute'}"
    end
  end
  
end
