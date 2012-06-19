module AgendaHelper
  
  def get_activity_end(hour, duration)
    h1, m1 = get_hour_mins hour
    hd, md = get_hour_mins duration
    h2 = h1 + hd
    m2 = m1 + md
    h2 += m2 / 60
    m2 %= 60
    "#{h2}h#{m2 < 10 ? "0#{m2}" : m2}"
  end
  
  private
  
  def get_hour_mins(time)
    h, m = time.split 'h'
    h = h.to_i
    m = m.to_i
    [h, m]
  end
  
end
