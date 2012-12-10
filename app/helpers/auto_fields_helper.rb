
module AutoFieldsHelper
	def auto_fields_settings_tabs
		tabs = [{:name => 'auto_fields', :action => :index, :partial => 'auto_fields/auto_fields', :label => :label_auto_fields},
				{:name => 'hidden_fields', :action => :index, :partial => 'hidden_fields/hidden_fields', :label => :label_hidden_fields},
				{:name => 'disabled_fields', :action => :index, :partial => 'disabled_fields/disabled_fields', :label => :label_disabled_fields},
				{:name => 'required_fields', :action => :index, :partial => 'required_fields/required_fields', :label => :label_required_fields},
				{:name => 'tracker_roles', :action => :index, :partial => 'tracker_roles/tracker_roles', :label => :label_tracker_roles}
				]	
	end
  
  def get_role_names(role_ids)
	if(!role_ids.to_a.include?("nothing"))
		roles=Role.find(:all, :select => 'id, name, builtin', :conditions => [ "id IN (?)", role_ids])
		i=0
		html="".html_safe
		for r in roles
			html+=" #{l(:or)} ".html_safe if i!=0
			html+= link_to r.name, { :controller => 'roles', :action => 'edit', :id => r.id }
			i+=1
		end
		html.html_safe
		if !role_ids.nil?
			if (role_ids.include?("0"))
				l(:any)
			else
				(roles.size.to_i>0) ? html : l(:any)
			end
		end
	else
		"x"
	end
  end
  
  def get_status_names(status_ids)
	statuses=IssueStatus.find(:all, :select => 'name', :conditions => [ "id IN (?)", status_ids])
	r="".html_safe;
	if (statuses.size.to_i>0 || status_ids.try(:include?, "nothing")) 
		r= "&laquo;#{statuses.join('&raquo; '+l(:or)+' &laquo;')}&raquo; ".html_safe if statuses.size.to_i>0
		r+= l(:or).html_safe if statuses.size.to_i>0 && status_ids.try(:include?, "nothing")
		r+= " &laquo;#{l(:nothing_status_label)}&raquo;".html_safe if status_ids.try(:include?, "nothing")
	else
		r = l(:any)
	end
		r
  end

  def get_trakers_names(trakers_ids)
	trakers=Tracker.find(:all, :select => 'name', :conditions => [ "id IN (?)", trakers_ids])
	(trakers.size.to_i>0) ? "&laquo;#{trakers.join('&raquo; '+l(:or)+' &laquo;')}&raquo;".html_safe : l(:any)
  end  
  
  def get_project_names(project_ids)
	projects=Project.find(:all, :select => 'name', :conditions => [ "id IN (?)", project_ids])
	(projects.size.to_i>0) ? "&laquo;#{projects.join('&raquo; '+l(:or)+' &laquo;')}&raquo;".html_safe : l(:any)
  end    
 
  def get_custom_field_names(custom_field_ids)
	if(!custom_field_ids.to_a.include?("nothing"))
		if(!custom_field_ids.to_a.include?("0"))
			custom_fields=CustomField.find(:all, :select => 'name', :conditions => [ "id IN (?)", custom_field_ids.to_a])
			html="".html_safe
			i=0
			for r in custom_fields
				html+=" #{l(:or)} ".html_safe if i!=0
				html+= " &laquo;#{r.name}&raquo; ".html_safe
				i+=1
			end
			(custom_fields.size.to_i>0) ? html : l(:any)
		else
			l(:any)
		end
	else
		"x"
	end
  end  

  def get_issue_field_names(issue_field_ids, issue_fields)
		issue_field_names=Array.new
		issue_fields=issue_fields.flatten
		issue_fields.each_index{|k|
			if issue_field_ids.include?(issue_fields[k])
				issue_field_names.push(issue_fields[k-1])
			end
			}
		s=(issue_field_names.size.to_i>0) ? "&laquo;#{issue_field_names.join('&raquo;, &laquo;')}&raquo;".html_safe : l(:any)
		s="x" if issue_field_ids.include?("nothing")
		s
  end    
  
	def get_auto_field_patterns
		patterns={}
		
		patterns[l(:label_for_sb_current_user)]="current_user"
		patterns[l(:label_for_sb_author)]="author"
		patterns[l(:label_for_sb_nobody)]="nobody"		
		patterns[l(:label_for_sb_assigned_to)]="assigned_to"		
		patterns[l(:label_for_sb_current_date)]="current_date"		
		
		return patterns
	end
   
end