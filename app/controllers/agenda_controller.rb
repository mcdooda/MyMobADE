class AgendaController < ApplicationController
  before_filter :check_logged_in

  private
  
  def check_logged_in
    unless logged_in?
      ade_clear
      redirect_to controller: :login, action: :login
    end
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
    @title = "Aujourd'hui"
    @agenda = ade_load.day_agenda
    sort_agenda_per_day
    render 'all'
  end

  def week
    @title = "Cette semaine"
    @agenda = ade_load.week_agenda
    sort_agenda_per_day
    render 'all'
  end

  def month
    @title = "Ce mois-ci"
  end

  def all
    @title = "La totale"
    @agenda = ade_load.full_agenda
    sort_agenda_per_day
  end
  
end
