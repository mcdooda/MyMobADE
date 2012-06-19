require 'rubygems'
require 'mechanize'

module Ade
  
  class Reader
    
    def initialize(config)
      @config = config
      
      @agent = Mechanize.new
      @agent.user_agent = 'MyMobAde'
      
      @project_id = nil
      @category = nil
      @branch_id = nil
    end
    
    def get(page)
      @agent.get(@config.ade_path + page)
    end
    
    def login
      page = get 'standard/index.jsp?lang=FR'
      
      login_form = page.form_with({ name: 'projects' })
      if @config.domain
        login_form.field_with({ name: 'username' }).value = @config.login
        login_form.field_with({ name: 'password' }).value = @config.password
        login_form.field_with({ name: 'domain' }).value = @config.domain
      else
        login_form.field_with({ name: 'login' }).value = @config.login
        login_form.field_with({ name: 'password' }).value = @config.password
      end
      
      @agent.submit login_form
    end
    
    def select_project
      page = get 'standard/projects.jsp'
      
      page.parser.css('select[name=\'projectId\']').children.each do |option|
        project_id = option.get_attribute('value').to_i
        project_name = option.content.strip
        @project_id = project_id if @config.project == project_name
      end
      
      projects_form = page.form_with name: 'projects'
      projects_form.field_with({ name: 'projectId' }).value = @project_id
      
      @agent.submit projects_form
    end
    
    def select_category
      page = get 'standard/gui/tree.jsp'
      
      regex = /'(.+)'/
      page.parser.css('.treeline').each do |div|
        link = div.css('a')[1]
        link_category = regex.match(link.get_attribute('href'))[1]
        link_name = link.content.strip
        @category = link_category if link_name == @config.resource_path[0]
      end
    end
    
    def select_branch
      page = get('standard/gui/tree.jsp?category=' + @category + '&expand=false&forceLoad=false&reload=false&scroll=0')
      
      regex = /\((.+),/
      branch_id = nil
      
      (1...@config.resource_path.length).each do |i|
        branch_id = nil
        branch_name = @config.resource_path[i]
        
        if i < @config.resource_path.length - 1
          page.parser.css('.treebranch a').each do |link|
            link_branch_id = regex.match(link.get_attribute('href'))[1]
            link_name = link.content.strip
            branch_id = link_branch_id if link_name == branch_name
          end
          
          page = get('standard/gui/tree.jsp?branchId=' + branch_id + '&expand=false&forceLoad=false&reload=false&scroll=0')
        else
          page.parser.css('.treeitem a').each do |link|
            link_branch_id = regex.match(link.get_attribute('href'))[1]
            link_name = link.content.strip
            branch_id = link_branch_id if link_name == branch_name
          end
          
          #page = get('standard/gui/tree.jsp?selectId=' + branch_id + '&reset=true&forceLoad=false&scroll=0')
          page = get('custom/modules/plannings/direct_planning.jsp?resources=' + branch_id)
        end
      end
      
      @branch_id = branch_id
    end
    
    def select_table_view_options
      page = get 'custom/modules/plannings/appletparams.jsp'
      
      options_form = page.form_with name: 'form12'
      
      [
        # Activites
        ["showTabActivity", true],  # Nom
        ["showTabWeek", false],
        ["showTabDay", true],       # Jour
        ["showTabStage", false],
        ["showTabDate", true],      # Date
        ["showTabHour", true],      # Heure
        ["aC", false],
        ["aTy", false],
        ["aUrl", false],
        ["showTabDuration", true],  # Duree
        ["aSize", false],
        ["aMx", false],
        ["aSl", false],
        ["aCx", false],
        ["aCy", false],
        ["aCz", false],
        ["aTz", false],
        ["aN", false],
        ["aNe", false],

        # Etudiants
        ["showTabTrainees", false],
        ["sC", false],
        ["sTy", false],
        ["sUrl", false],
        ["sE", false],
        ["sM", false],
        ["sJ", false],
        ["sA1", false],
        ["sA2", false],
        ["sZp", false],
        ["sCi", false],
        ["sSt", false],
        ["sCt", false],
        ["sT", false],
        ["sF", false],
        ["sCx", false],
        ["sCy", false],
        ["sCz", false],
        ["sTz", false],

        # Enseignants
        ["showTabInstructors", true], # nom des enseignants
        ["iC", false],
        ["iTy", false],
        ["iUrl", false],
        ["iE", false],
        ["iM", false],
        ["iJ", false],
        ["iA1", false],
        ["iA2", false],
        ["iZp", false],
        ["iCi", false],
        ["iSt", false],
        ["iCt", false],
        ["iT", false],
        ["iF", false],
        ["iCx", false],
        ["iCy", false],
        ["iCz", false],
        ["iTz", false],

        # Salles
        ["showTabRooms", true], # numero de salle
        ["roC", false],
        ["roTy", false],
        ["roUrl", false],
        ["roE", false],
        ["roM", false],
        ["roJ", false],
        ["roA1", false],
        ["roA2", false],
        ["roZp", false],
        ["roCi", false],
        ["roSt", false],
        ["roCt", false],
        ["roT", false],
        ["roF", false],
        ["roCx", false],
        ["roCy", false],
        ["roCz", false],
        ["roTz", false],

        # Equipements
        ["showTabResources", false],
        ["reC", false],
        ["reTy", false],
        ["reUrl", false],
        ["reE", false],
        ["reM", false],
        ["reJ", false],
        ["reA1", false],
        ["reA2", false],
        ["reZp", false],
        ["reCi", false],
        ["reSt", false],
        ["reCt", false],
        ["reT", false],
        ["reF", false],
        ["reCx", false],
        ["reCy", false],
        ["reCz", false],
        ["reTz", false],

        # Unites d'enseignement
        ["showTabCategory5", false],
        ["c5C", false],
        ["c5Ty", false],
        ["c5Url", false],
        ["c5E", false],
        ["c5M", false],
        ["c5J", false],
        ["c5A1", false],
        ["c5A2", false],
        ["c5Zp", false],
        ["c5Ci", false],
        ["c5St", false],
        ["c5Ct", false],
        ["c5T", false],
        ["c5F", false],
        ["c5Cx", false],
        ["c5Cy", false],
        ["c5Cz", false],
        ["c5Tz", false],

        # Matieres
        ["showTabCategory6", false],
        ["c6C", false],
        ["c6Ty", false],
        ["c6Url", false],
        ["c6E", false],
        ["c6M", false],
        ["c6J", false],
        ["c6A1", false],
        ["c6A2", false],
        ["c6Zp", false],
        ["c6Ci", false],
        ["c6St", false],
        ["c6Ct", false],
        ["c6T", false],
        ["c6F", false],
        ["c6Cx", false],
        ["c6Cy", false],
        ["c6Cz", false],
        ["c6Tz", false],

        # Categorie7
        ["showTabCategory7", false],
        ["c7C", false],
        ["c7Ty", false],
        ["c7Url", false],
        ["c7E", false],
        ["c7M", false],
        ["c7J", false],
        ["c7A1", false],
        ["c7A2", false],
        ["c7Zp", false],
        ["c7Ci", false],
        ["c7St", false],
        ["c7Ct", false],
        ["c7T", false],
        ["c7F", false],
        ["c7Cx", false],
        ["c7Cy", false],
        ["c7Cz", false],
        ["c7Tz", false],

        # Categorie8
        ["showTabCategory8", false],
        ["c8C", false],
        ["c8Ty", false],
        ["c8Url", false],
        ["c8E", false],
        ["c8M", false],
        ["c8J", false],
        ["c8A1", false],
        ["c8A2", false],
        ["c8Zp", false],
        ["c8Ci", false],
        ["c8St", false],
        ["c8Ct", false],
        ["c8T", false],
        ["c8F", false],
        ["c8Cx", false],
        ["c8Cy", false],
        ["c8Cz", false],
        ["c8Tz", false]
      ].each do |field, check|
        if options_form.hidden_field? field
          hiddenfield = options_form.field_with name: field
          if check
            hiddenfield.value = "true"
          else
            hiddenfield.value = "false"
          end
        else
          checkbox = options_form.checkbox_with name: field
          if check
            checkbox.check
            checkbox.value = "true"
          else
            checkbox.uncheck
            checkbox.value = "false" # certainly useless
          end
        end
      end
      
      @agent.submit options_form
    end
    
    def get_full_agenda
      get 'custom/modules/plannings/pianoWeeks.jsp?forceLoad=true'
      get 'custom/modules/plannings/pianoWeeks.jsp?searchWeeks=all'
      page = get 'custom/modules/plannings/info.jsp?order=slot&light=true'
      
      return parse_agenda page
    end
    
    private
    
    def parse_agenda(page)
      agenda = []
      i = 1
      page.parser.css('tr').each do |tr|
        if tr.get_attribute('class').nil?
          tds = tr.css 'td'
          activity = Activity.new({
            date: tds[0].children.first.content,
            name: tds[1].content,
            day: tds[2].content,
            hour: tds[3].content,
            duration: tds[4].content,
            teachers: tds[5].content,
            rooms: tds[6].content
          })
          agenda << activity
        end
      end
      return agenda
    end
    
  end
  
end
