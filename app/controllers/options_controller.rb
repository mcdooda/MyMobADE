class OptionsController < ApplicationController
  before_filter :check_logged_in, :load_ade
  after_filter :save_ade  
  
  def options
    @bookmark_week_link = bookmark_link
    @bookmark_day_link = bookmark_link :day
    render layout: false
  end
end
