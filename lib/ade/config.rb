module Ade
	
	class Config
		attr_accessor :ade_path, :login, :password, :domain, :project, :resource_path, :branch_id
		
		def initialize
			@ade_path = nil
			@login = ''
			@password = ''
			@domain = nil
			@project = nil
			@resource_path = []
			@branch_id = nil
		end
		
		def to_s
			"ade path: #{@ade_path}\n" +
			"login: #{@login}\n" +
			"password: #{@password}\n" +
			"domain: #{(@domain.nil? ? "<none>" : @domain)}\n" +
			"project: #{(@project.nil? ? "<none>" : @project)}\n" +
			"resource path: #{@resource_path}\n"
		end
		
		def <<(path)
			if path.respond_to? :each
				path.each { |path| @resource_path << path }
			else
				@resource_path << path
			end
		end
	end
	
end
