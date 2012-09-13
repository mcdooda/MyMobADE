class BookmarkController < ApplicationController
  before_filter :load_ade
  after_filter :save_ade  
  
  def login
    unless logged_in?
      # log in
      domain = nil
      domain = params[:domain_] unless params[:domain_] == '-'
      
      begin
        @ade.login params[:username], params[:password], domain
              
        # project
        @ade.projects
        if params[:project_id] != '-'
          project_id = params[:project_id].to_i
          @ade.project_id = project_id
        end
        
        # category
        @ade.categories
        @ade.category_id = params[:category_id]
        
        # branches
        params[:branches_id].split(',').each do |branch_id|
          @ade.branches
          @ade.branch_id = branch_id
        end
        
        # options
        @ade.setup_table_view_options
        @ade.find_current_week
        
        # creates a cookie
        log_in
      rescue Ade::Exceptions::LoginError
        redirect_to controller: :login, action: :login
        return
      end
    end
    
    redirect_to controller: :agenda, action: :week
  end
  
end
