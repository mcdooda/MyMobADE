class OptionsController < ApplicationController
  before_filter :check_logged_in, :load_ade
  after_filter :save_ade  
  
  def options
    render layout: false
  end
end
