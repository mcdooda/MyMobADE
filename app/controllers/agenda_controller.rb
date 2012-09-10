# coding: utf-8

class AgendaController < ApplicationController
  before_filter :check_logged_in, :load_ade
  after_filter :save_ade

  private

  def sort_agenda_per_day
    @agenda_per_day = {}
    @agenda.each do |activity|
      key = "#{activity.day} #{activity.date}"
      @agenda_per_day[key] = [] unless @agenda_per_day.key? key
      @agenda_per_day[key] << activity
    end
  end
  
  def get_day(day)
    ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'][day]
  end
  
  def get_month(month)
    ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'][month - 1]
  end
  
  public
  
  def day
    if params[:week_id] and params[:day_id]
      @ade.selected_week = params[:week_id].to_i
      @ade.selected_day = params[:day_id].to_i
    end
    
    @agenda = @ade.day_agenda
    
    @current_week = @ade.current_week
    @current_day = @ade.current_day
    
    @previous_week = @ade.selected_week
    @next_week = @previous_week
    @previous_day = @ade.selected_day - 1
    @next_day = @ade.selected_day + 1
    
    if @previous_day < 0
      @previous_week -= 1
      @previous_day = 6
    elsif @next_day > 6
      @next_week += 1
      @next_day = 0
    end
    
    @previous_week = nil if @previous_week < 0
    @next_week = nil if @next_week > @ade.last_week
    
    day = Date.commercial(Date.today.year, @ade.selected_week - (@ade.current_week - Date.today.cweek), @ade.selected_day % 7 + 1)
    
    @title = "#{get_day @ade.selected_day} #{day.day} #{get_month day.month} #{day.year}"
    
    sort_agenda_per_day
  end

  def week
    if params[:week_id]
      @ade.selected_week = params[:week_id].to_i
    end
    
    @agenda = @ade.week_agenda
    
    @current_week = @ade.current_week
    
    @previous_week = @ade.selected_week - 1 if @ade.selected_week > 0
    @next_week = @ade.selected_week + 1 if @ade.selected_week < @ade.last_week
    
    cweek = Date.today.cweek - (@ade.current_week - @ade.selected_week)
    cyear = Date.today.year
    
    while cweek < 1
      cweek += 52
      cyear -= 1
   	end
   	
   	while cweek > 52
   	  cweek -= 52
   	  cyear += 1
   	end
    
    week = Date.commercial(cyear, cweek)
    week = week.next_week if Date.today.wday == 0
    
    @title = "Semaine du #{week.day} #{get_month week.month} #{week.year}"
    sort_agenda_per_day
  end

  def all
    @title = "La totale"
    @agenda = @ade.full_agenda
    sort_agenda_per_day
  end
  
end
