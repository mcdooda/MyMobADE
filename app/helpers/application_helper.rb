module ApplicationHelper
  
  def logged_in?
    cookies[:logged_in] != nil
  end
  
  def theme
    'c'
  end
  
  def info_theme
    'b'
  end
  
  def error_theme
    'e'
  end
  
end
