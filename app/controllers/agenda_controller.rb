class AgendaController < ApplicationController
  before_filter :open_agenda
  
  private
  
  def open_agenda
    @reader = Ade::Reader.new Ade::Schools::Classes::L3infog2.new
    @reader.login
    @reader.select_project
    @reader.select_category
    @reader.select_branch
    @reader.select_table_view_options
  end
  
  def sort_agenda_per_day
    @agenda_per_day = {}
    @agenda.each do |activity|
      key = "#{activity.day} #{activity.date}"
      @agenda_per_day[key] = [] unless @agenda_per_day.key? key
      @agenda_per_day[key] << activity
    end
  end
  
  public
  
  def day
    @agenda = @reader.get_day_agenda
    sort_agenda_per_day
    @agenda_title = 'L3 Info G2 S2'
    render 'all'
  end

  def week
    @agenda = @reader.get_week_agenda
    sort_agenda_per_day
    @agenda_title = 'L3 Info G2 S2'
    render 'all'
  end

  def month
  end

  def all
    @agenda = @reader.get_full_agenda
    sort_agenda_per_day
    @agenda_title = 'L3 Info G2 S2'
  end
  
end
