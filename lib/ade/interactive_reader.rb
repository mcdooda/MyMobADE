require 'rubygems'
require 'mechanize'
require 'stringio'

module Ade

  class InteractiveReader
    
    def initialize(config)
      @config = config
      
      @agent = Mechanize.new
      @agent.user_agent = 'MyMobAde'
      
      @page = nil # kept between each user input
      @branch_level = 1
      @leaf = false
      @category_id = nil
      @branch_id = nil
      @enabled_days = [true, true, true, true, true, true, true]
      @logged_in = false
    end
    
    def marshal_dump
      strio = StringIO.new
      @agent.cookie_jar.dump_cookiestxt strio
      ade_cookies = strio.string
      strio.close
      [@branch_level, @leaf, @category_id, @branch_id, @config, @enabled_days, @logged_in, ade_cookies]
    end
    
    def marshal_load(array)
      @branch_level, @leaf, @category_id, @branch_id, @config, @enabled_days, @logged_in, ade_cookies = array
      @agent = Mechanize.new
      strio = StringIO.new
      strio << ade_cookies
      strio.rewind
      @agent.cookie_jar.load_cookiestxt strio
      strio.close
    end
    
    def leaf?
      @leaf
    end
    
    private
    
    def get(page)
      puts
      puts
      puts "***** LOADING: #{@config.ade_path + page}"
      @agent.get(@config.ade_path + page)
    end
    
    public
    
    def login(login, password, domain)
      @page = get 'standard/index.jsp?lang=FR'
      
      login_form = @page.form_with({ name: 'projects' })
      if domain
        login_form.field_with({ name: 'username' }).value = login
        login_form.field_with({ name: 'password' }).value = password
        login_form.field_with({ name: 'domain' }).value = domain
      else
        login_form.field_with({ name: 'login' }).value = login
        login_form.field_with({ name: 'password' }).value = password
      end
      
      @agent.submit login_form
      
      location_regex = /top\.document\.location=\'(.+)\.jsp\'/
      match = location_regex.match(@agent.page.content)
      
      case match[1]
      when 'projects' # may be something else if there is only one project
        @logged_in = true
      else # probably index
        
      end
    end
    
    def logged_in?
      @logged_in
    end
    
    def projects
      @page = get 'standard/projects.jsp'
      
      projects = []
      
      @page.parser.css('select[name=\'projectId\']').children.each do |option|
        project_id = option.get_attribute('value').to_i
        project_name = option.content.strip
        projects << { id: project_id, name: project_name }
      end
      
      projects
    end
    
    def project=(project)
      self.project_id = project[:id]
    end
    
    def project_id=(project_id)
      @page = get 'standard/projects.jsp' if @page.nil?
      
      projects_form = @page.form_with name: 'projects'
      projects_form.field_with({ name: 'projectId' }).value = project_id
      
      @agent.submit projects_form
    end
    
    def categories
      @page = get 'standard/gui/tree.jsp'
      
      categories = []
      
      regex = /'(.+)'/
      @page.parser.css('.treeline').each do |div|
        link = div.css('a')[1]
        category_id = regex.match(link.get_attribute('href'))[1]
        category_name = link.content.strip
        categories << { id: category_id, name: category_name }
      end
      
      categories
    end
    
    def category=(category)
      self.category_id = category[:id]
    end
    
    def category_id=(category_id)
      @category_id = category_id
      @page = get('standard/gui/tree.jsp?category=' + category_id + '&expand=false&forceLoad=false&reload=false&scroll=0')
    end
    
    def branches
      branches = []
      
      branch_level_str = '&nbsp;' * 3 * @branch_level
      branch_regex = /openBranch\((.+)\)/
      item_regex = /check\((.+),/
      
      if @page.nil?
        if @branch_level == 1
          # FFFUUUUUU
          get('standard/gui/tree.jsp?category=' + @category_id + '&expand=true&forceLoad=false&reload=false&scroll=0')
          @page = get('standard/gui/tree.jsp?category=' + @category_id + '&expand=true&forceLoad=false&reload=false&scroll=0')
        else
          @page = get('standard/gui/tree.jsp?branchId=' + @branch_id + '&expand=false&forceLoad=false&reload=false&scroll=0')
        end
      end
      
      @page.encoding = 'ascii-8bit'
      @page.parser.css('.treeline').each do |treeline|
        treeline_str = treeline.to_s
        if treeline_str.include? branch_level_str
          match = branch_regex.match(treeline_str)
          if match
            branch_id = match[1]
            branch_name = treeline.css('.treebranch a')[0].text
            branches << { id: branch_id, name: branch_name }
          else
            @leaf = true
            branch_id = item_regex.match(treeline_str)[1]
            branch_name = treeline.css('.treeitem a')[0].text
            branches << { id: branch_id, name: branch_name }
          end
        end
      end
      
      branches
    end
    
    def branch=(branch)
      self.branch_id = branch[:id]
    end
    
    def branch_id=(branch_id)
      if not @leaf
        @page = get('standard/gui/tree.jsp?branchId=' + branch_id + '&expand=false&forceLoad=false&reload=false&scroll=0')
        @branch_level += 1
      else
        @page = get('custom/modules/plannings/direct_planning.jsp?resources=' + branch_id)
      end
    end
    
    def setup_table_view_options
      @page = get 'custom/modules/plannings/appletparams.jsp'
      
      options_form = @page.form_with name: 'form12'
      
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
    
    def day_agenda
      enable_day(Time.new.wday - 1, true)
      @page = get 'custom/modules/plannings/info.jsp?order=slot&light=true'
      parse_agenda
    end
    
    def week_agenda # not working
      enable_all_days
      @page = get 'custom/modules/plannings/info.jsp?order=slot&light=true'
      parse_agenda
    end
    
    def month_agenda # not working
      enable_all_days
      @page = get 'custom/modules/plannings/info.jsp?order=slot&light=true'
      parse_agenda
    end
    
    def full_agenda
      enable_all_days
      get 'custom/modules/plannings/pianoWeeks.jsp?searchWeeks=all'
      @page = get 'custom/modules/plannings/info.jsp?order=slot&light=true'
      parse_agenda
    end
    
    private
    
    def enable_day(day, reset)
      @enabled_days.fill { |d| d == day }
      get 'custom/modules/plannings/pianoDays.jsp?day=' + day.to_s + '&reset=' + reset.to_s
    end
    
    def enable_all_days
      day = 0
      @enabled_days.each do |enabled|
        unless enabled
          get 'custom/modules/plannings/pianoDays.jsp?day=' + day.to_s + '&reset=false'
          @enabled_days[day] = true
        end
        day += 1
      end
    end
    
    def parse_agenda
      agenda = []
      i = 1
      @page.parser.css('tr').each do |tr|
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
      agenda
    end
    
  end
  
end
