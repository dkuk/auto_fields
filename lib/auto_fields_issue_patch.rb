require_dependency 'issue'
require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module AutoFieldsIssuePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
		before_save :update_custom_fields
		validate :check_additional_presence
		#alias_method_chain :available_custom_fields, :auto_fields if(Setting.plugin_auto_fields['enable'] == 'true')
    end

  end

  module ClassMethods   
  # Methods to add to the Issue class  

	def get_issue_fields
	[[l(:field_tracker), 'issue_tracker_id'], 
						[l(:field_status), 'issue_status_id'],
						[l(:field_parent_issue), 'issue_parent_issue_id'],
						[l(:field_category), 'issue_category_id'],
						[l(:field_assigned_to), 'issue_assigned_to_id'],
						[l(:field_priority), 'issue_priority_id'],
						[l(:field_fixed_version), 'issue_fixed_version_id'],
						[l(:field_subject), 'issue_subject'],
						[l(:field_description), 'issue_description'],
						[l(:field_start_date), 'issue_start_date'],
						[l(:field_due_date), 'issue_due_date'],
						[l(:field_done_ratio), 'issue_done_ratio'],
						[l(:field_estimated_hours), 'issue_estimated_hours'],
						[l(:field_is_private), 'issue_is_private'],
						[l(:field_notes), 'notes'],
						[l(:label_file_plural), 'attachments_fields'],
						[l(:field_check_date), 'issue_check_date'],
						[l(:field_executor), 'issue_executor_id'],
						[l(:label_project), 'issue_project_id']
						]	
	end
	
	def get_all_issue_fields
	all_issue_fields=[]
	prohibited_fields=["lft", "rgt", "lock_version", "root_id", "id"]
	
	available_columns=Issue.first
	field_values = available_columns.attributes
	field_values.each do |key, value| 
		if(!prohibited_fields.include?(key))
			all_issue_fields.push([l('field_'+key.to_s.sub('_id', '')), key])
		end
	end 
	all_issue_fields						
	end
	
	
	def get_issue_fields_available_for_hidden
		get_issue_fields << [l(:field_tags), 'issue_tags'] << [l(:field_issue_checklist), 'issue_checklist_form'] << [l(:field_watchers), 'watchers_form'] << [l(:label_time_entry_plural), 'time_entry_hours'] << [l(:field_activity), 'time_entry_activity_id'] << [l(:label_time_entry_comments), 'time_entry_comments']
	end
	
	def get_issue_fields_available_for_required
	[[l(:field_tracker), 'issue_tracker_id'], 
						[l(:field_status), 'issue_status_id'],
						[l(:field_parent_issue), 'issue_parent_issue_id'],
						[l(:field_category), 'issue_category_id'],
						[l(:field_assigned_to), 'issue_assigned_to_id'],
						[l(:field_priority), 'issue_priority_id'],
						[l(:field_description), 'issue_description'],
						[l(:field_fixed_version), 'issue_fixed_version_id'],
						[l(:field_subject), 'issue_subject'],
						[l(:field_start_date), 'issue_start_date'],
						[l(:field_due_date), 'issue_due_date'],
						[l(:field_done_ratio), 'issue_done_ratio'],
						[l(:field_estimated_hours), 'issue_estimated_hours']
						]	
	end	
  end

  module InstanceMethods

	def get_available_issue_trackers
		current_user_roles_in_project=User.current.roles_for_project(self.project).map{|role| role.id.to_s}
		trackers=[]

		TrackerRole.find(:all).each{|f|
				if (((f.role_id & current_user_roles_in_project) != [] or f.role_id.include?("0")) and (f.project_id.include?(self.project.id.to_s) or f.project_id.include?("0")))
					trackers.push(f.tracker_id)
				end
				}
		trackers.flatten.uniq
	end
  
	def check_additional_presence
		required=Issue.get_issue_fields_available_for_required
		required_flat=required.flatten
		current_issue=Issue.find_by_id(self.id)
		ar=[]
		fields=[]
		c_fields=[]
		
		self.project.members.find(:all, :include => [:user, :roles], :conditions => "users.id="+User.current.id.to_s).each{ |m|
				m.roles.each { |r|
					ar.push(r.id.to_s)
				}
			}
				
		if(ar.size==0)
			if(User.current.nil?)
				ar+=Role.find(:all, :conditions=>"builtin=2").map{|e| e.id.to_s}
			else
				ar+=Role.find(:all, :conditions=>"builtin=1").map{|e| e.id.to_s}
			end
		end		

		#check available trackers

		current_issue_tracker_id = (current_issue.nil?) ? 0 : current_issue.tracker_id

		if get_available_issue_trackers.include? current_issue_tracker_id.to_s or current_issue_tracker_id==0
			#errors.add(:base, "#{l(:you_should_not_save_this_tracker)} #{current_issue.tracker_id.to_s} #{self.tracker_id.to_s} sada".html_safe)
			if !get_available_issue_trackers.include? self.tracker_id.to_s
				errors.add(:base, "#{l(:you_should_not_save_this_tracker)} ".html_safe)
			end
		else
			if self.tracker_id!=current_issue_tracker_id
				errors.add(:base, "#{l(:you_should_not_save_this_tracker)} ".html_safe)
			end
		end
			
		rf=RequiredField.find(:all)
		rf.each{|f| 
				if ((f.role_id & ar) != [] or f.role_id.include?("0") ) and (f.status_id.include?(status_id.to_s) or f.status_id.include?("0")) and (f.tracker_id.include?(tracker_id.to_s) or f.tracker_id.include?("0"))
					if(f.no_role_id.include?("nothing") || ((!f.no_role_id.include?("nothing")) && f.no_role_id.include?("0") && (ar.size==1)) || ((!f.no_role_id.include?("nothing")) && (!f.no_role_id.include?("0")) && ((f.no_role_id & ar)==[])) ) #Check that role is not						
						if !f.issue_field.include?("nothing")
							if f.issue_field.include?("0")
								fields.push(required.map{|a| a[1]})
							else
								fields.push(f.issue_field)
							end	
						end

						if !f.custom_field_id.include?("nothing")
							if f.custom_field_id.include?("0")
								c_fields.push(CustomField.find(:all, :order => "name ASC", :conditions=>"type='IssueCustomField'").map{|e| e.id.to_i})
							else
								c_fields.push(f.custom_field_id.map{|e| e.to_i})		
							end	
						end
					end
				end
			}	

		fields.flatten.uniq.each{|v|
			if(instance_eval(v.sub('issue_', '')).blank?)
				errors.add(v.sub('issue_', ''), l(:should_not_be_blank))
			end
			}
			
		self.custom_field_values.each {|c|
			c_fields.flatten.uniq.each {|f|
				if c.custom_field_id.to_s==f.to_s
					errors.add(:base, "&laquo;#{CustomField.find_by_id(c.custom_field_id).name}&raquo; #{l(:should_not_be_blank)} ".html_safe) if c.value.blank?
				end
				}
			}
	end    
   
    # Methods to add to specific issue objects
    def update_custom_fields
		auto_fields=AutoField.find(:all)
		tracker_roles=TrackerRole.find(:all)
		current_issue=Issue.find_by_id(self.id)
		
		if current_issue
			old_status_id=current_issue.status_id
		else
			old_status_id="nothing"
		end
		
		#self.subject+="--"+current_issue.tracker_id.to_s+"--"
		
		user_roles_in_pr=[]
		
		self.project.members.find(:all, :include => [:user, :roles], :conditions => "users.id="+User.current.id.to_s).each{ |m|
				m.roles.each { |r|
					user_roles_in_pr.push(r.id.to_s)
				}
			}
		if(user_roles_in_pr.size==0)
			if(User.current.nil?)
				user_roles_in_pr+=Role.find(:all, :conditions=>"builtin=2").map{|e| e.id.to_s}
			else
				user_roles_in_pr+=Role.find(:all, :conditions=>"builtin=1").map{|e| e.id.to_s}
			end
		end		

	   
	   if(Setting.plugin_auto_fields['enable'] == 'true')
		   p={}
		   self.custom_field_values.each { |v| 
				auto_fields.each { |f|
					if v.custom_field_id==f.custom_field_id
						if ((f.role_id & user_roles_in_pr) != [] or f.role_id.include?("0") )
							if (f.tracker_id.include?(self.tracker_id.to_s) or f.tracker_id.include?("0"))
								if (f.current_status_id.include?(old_status_id.to_s) or f.current_status_id.include?("0"))
									if (f.updated_status_id.include?(self.status_id.to_s) or f.updated_status_id.include?("0"))
										if (!f.no_rewrite) || (f.no_rewrite && v.value.to_s=="")
											case f.pattern.to_s
											when "current_user"
												p[v.custom_field_id.to_s] = User.current.id.to_s
											when "author"
												p[v.custom_field_id.to_s] = self.author_id.to_s
											when "assigned_to"
												p[v.custom_field_id.to_s] = self.assigned_to_id.to_s					
											when "current_date"
												p[v.custom_field_id.to_s] = Date.today.to_s
											when "nobody"
												p[v.custom_field_id.to_s] = nil												
											end	
											break
										else
											p[v.custom_field_id.to_s] = v.value
										end
									else
										p[v.custom_field_id.to_s] = v.value
									end

								
								#b=self.status_id.to_s+"----"+af.status_id.to_s+"--"+v.custom_field_id.to_s+"--"+p[v.custom_field_id.to_s]
								else
									p[v.custom_field_id.to_s] = v.value
								end
							else
								p[v.custom_field_id.to_s] = v.value
							end							
						else
							p[v.custom_field_id.to_s] = v.value
						end
					else
						p[v.custom_field_id.to_s] = v.value
					end
					}
				}
			self.custom_field_values=p
		   
			substitution=nil
			auto_fields.each { |f|
				if(f.issue_field.to_s!='nothing')
					if ((f.role_id & user_roles_in_pr) != [] or f.role_id.include?("0") )
						if (f.tracker_id.include?(self.tracker_id.to_s) or f.tracker_id.include?("0"))
							if (f.current_status_id.include?(old_status_id.to_s) or f.current_status_id.include?("0"))
								if (f.updated_status_id.include?(self.status_id.to_s) or f.updated_status_id.include?("0"))
									if (!f.no_rewrite) || (f.no_rewrite && eval('self.'+f.issue_field.to_s)==nil)
										case f.pattern.to_s
											when "current_user"
												substitution = User.current.id.to_s
											when "author"
												substitution = self.author_id.to_s
											when "assigned_to"
												substitution = self.assigned_to_id.to_s					
											when "current_date"
												substitution = 'Date.today'										
											when "nobody"
												substitution = 'nil'				
										end	
										
										if(substitution!=nil && f.issue_field.to_s!='nothing')
											eval('self.'+f.issue_field.to_s+'='+substitution)
											#self.subject=f.issue_field.to_s+"-"+substitution+"----"+self.check_date.to_s+'-----'+Date.today.to_s
										end	
									end
								end
							end
						end
					end
				end
				}
			
			#p='536'
			#varrrr='executor_id'
			#eval('self.'+varrrr+'='+p)
	   end
    end	
  end
end

