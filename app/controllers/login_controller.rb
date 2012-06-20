# coding: utf-8

class LoginController < ApplicationController

  def login
    redirect_to controller: :agenda, action: :all if logged_in?
    
    @title = 'Connexion'
    
    unless params[:login].blank?
      login = params[:login].strip
      password = params[:password]
      domain = params[:domain] unless params[:domain].blank?
      
      ade_reader = ade_load
      ade_reader.login login, password, domain
      ade_save ade_reader
      
      redirect_to action: :project
    end
  end

  def project
    @title = 'Choisissez un projet'
    
    if params[:id]
      ade_reader = ade_load
      ade_reader.project_id = params[:id]
      ade_save ade_reader
      
      redirect_to action: :category
    else
      ade_reader = ade_load
      @projects = ade_reader.projects
      ade_save ade_reader
    end
  end

  def category
    @title = 'Choisissez une catégorie'
    
    if params[:id]
      ade_reader = ade_load
      ade_reader.category_id = params[:id]
      ade_save ade_reader
      
      redirect_to action: :branch
    else
      ade_reader = ade_load
      @categories = ade_reader.categories
      ade_save ade_reader
    end
  end

  def branch
    @title = 'Choisissez une branche'
    
    if not params[:leaf] == "true"
      ade_reader = ade_load
      ade_reader.branch_id = params[:id] if params[:id]
      @branches = ade_reader.branches
      @leaf = ade_reader.leaf?
      ade_save ade_reader
    else
      ade_reader = ade_load
      ade_reader.branch_id = params[:id]
      ade_reader.setup_table_view_options
      ade_save ade_reader
      
      redirect_to controller: :agenda, action: :all
    end
  end
  
end
