module ApplicationHelper
  
  def logged_in?
    cookies[:logged_in] != nil
  end
  
end
