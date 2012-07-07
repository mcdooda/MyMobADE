class LogoutController < ApplicationController
  
  def logout
    clear_cookies
    redirect_to controller: :login, action: :login
  end
  
end
