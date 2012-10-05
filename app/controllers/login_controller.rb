# coding: utf-8

class LoginController < ApplicationController
  before_filter :load_ade
  after_filter :save_ade
  
  def login
    if logged_in?
      redirect_to controller: :agenda, action: :all
      return
    else
      clear_cookies
      @title = 'Connexion'
      
      unless params[:login].blank?
        login = params[:login].strip
        password = params[:password]
        domain = params[:domain] unless params[:domain].blank?
        
        begin
          @ade.login login, password, domain
          redirect_to action: :project
        rescue Ade::Exceptions::LoginError
          flash.now[:error] = 'Mauvais login ou mot de passe.'
        end
        
      end
    end
  end

  def project
    @title = 'Choisissez un projet'
    
    if params[:project_id]
      @ade.project_id = params[:project_id]
      redirect_to action: :category
    else
      @projects = @ade.projects
      redirect_to action: :category if @projects.empty?
    end
  end

  def category
    @title = 'Choisissez une catégorie'
    
    if params[:category_id]
      @ade.category_id = params[:category_id]
      redirect_to action: :branch
    else
      @categories = @ade.categories
      if @categories.empty?
        flash[:error] = 'La sélection de votre emploi du temps a échoué.'
        redirect_to action: :login
        return
      else
        @categories.each do |category|
          if category[:name].blank?
            flash[:error] = 'La sélection de votre emploi du temps a échoué.'
            redirect_to action: :login
            return
          end
        end
      end
    end
  end

  def branch
    @title = 'Choisissez une branche'
    
    if params[:leaf] != "true"
      @ade.branch_id = params[:branch_id] if params[:branch_id]
      @branches = @ade.branches
      if @branches.empty?
        flash[:error] = 'La sélection de votre emploi du temps a échoué.'
        redirect_to action: :login
        return
      end
      @leaf = @ade.leaf?
    else
      @ade.branch_id = params[:branch_id]
      @ade.setup_table_view_options
      @ade.find_current_week
      
      log_in
      redirect_to controller: :agenda, action: :week
    end
  end
  
end
