# coding: utf-8

class LoginController < ApplicationController
  before_filter :load_ade
  after_filter :save_ade
  
  def login
    if logged_in?
      redirect_to controller: :agenda, action: :all
    else
      clear_cookies
      @title = 'Connexion'
      
      unless params[:login].blank?
        login = params[:login].strip
        password = params[:password]
        domain = params[:domain] unless params[:domain].blank?
        
        @ade.login login, password, domain
        
        redirect_to action: :project
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
    end
  end

  def category
    @title = 'Choisissez une catégorie'
    
    if params[:category_id]
      @ade.category_id = params[:category_id]
      redirect_to action: :branch
    else
      @categories = @ade.categories
    end
  end

  def branch
    @title = 'Choisissez une branche'
    
    if params[:leaf] != "true"
      @ade.branch_id = params[:branch_id] if params[:branch_id]
      @branches = @ade.branches
      @leaf = @ade.leaf?
    else
      @ade.branch_id = params[:branch_id]
      @ade.setup_table_view_options
      
      log_in
      redirect_to controller: :agenda, action: :all
    end
  end
  
end
