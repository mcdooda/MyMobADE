require 'tempfile'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    cookies[:logged_in] != nil
  end
  
  def log_in
    cookies[:logged_in] = true
  end
  
  def save_ade
    cookies[:ade] = Marshal.dump(@ade)
  end
  
  def load_ade
    if cookies[:ade]
      @ade = Marshal.load cookies[:ade]
    else
      @ade = Ade::InteractiveReader.new Ade::Schools::Ujf.new
    end
  end
  
  def clear_cookies
    cookies.delete :ade
    cookies.delete :logged_in
  end
  
end
