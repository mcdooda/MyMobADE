require_dependency 'lib/ade/schools/ujf'
require_dependency 'lib/ade/interactive_reader'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def check_logged_in
    unless logged_in?
      clear_cookies
      redirect_to controller: :login, action: :login
    end
  end
  
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
    [
      :ade,
      :logged_in
    ].each do |cookie|
      cookies[cookie] = nil
      cookies.delete cookie
    end
  end
  
end
