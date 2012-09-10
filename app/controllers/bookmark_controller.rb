class BookmarkController < ApplicationController
  before_filter :load_ade
  after_filter :save_ade  
  
  def login
    unless logged_in?
      # log in
      domain = nil
      domain = params[:domain_] unless params[:domain_] == '-'
      @ade.login params[:username], params[:password], domain
      
      puts "username = #{params[:username]} password = #{params[:password]} domain = #{domain}"
      
      unless @ade.logged_in?
        redirect_to controller: :login, action: :login
        return
      end
            
      # project
      projects = @ade.projects
      project_id = params[:project_id].to_i
      @ade.project_id = project_id if project_id >= 0
      
      # category
      categories = @ade.categories
      @ade.category_id = params[:category_id]
      
      # branches
      params[:branches_id].split(',').each do |branch_id|
        branches = @ade.branches
        @ade.branch_id = branch_id
      end
      
      # options
      @ade.setup_table_view_options
      @ade.find_current_week
      
      log_in
    end
    
    redirect_to controller: :agenda, action: :week
  end
  
end
