class AgendaController < ApplicationController
  before_filter :check_logged_in, :load_ade
  after_filter :save_ade

  private
  
  def check_logged_in
    unless logged_in?
      clear_cookies
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
    @agenda = @ade.day_agenda
    sort_agenda_per_day
    render 'all'
  end

  def week
    @title = "(non fonctionnel) Cette semaine"
    @agenda = @ade.week_agenda
    sort_agenda_per_day
    render 'all'
  end

  def month
    @title = "(non fonctionnel) Ce mois-ci"
    @agenda = @ade.month_agenda
    sort_agenda_per_day
    render 'all'
  end

  def all
    @title = "La totale"
    @agenda = @ade.full_agenda
    sort_agenda_per_day
  end
  
end
