# issue_patch.rb
require_dependency 'issues_helper'

module AutoFieldsIssuesHelperPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do

    end

  end

  module ClassMethods   
    # Methods to add to the Issue class
	def get_hidden_fields(issue)
		all_c_fields=CustomField.find(:all, :order => "name ASC", :conditions=>"type='IssueCustomField'").map{|e| "issue_custom_field_values_"+e.id.to_s}
		ar=[]
		issue.project.members.find(:all, :include => [:user, :roles], :conditions => "users.id="+User.current.id.to_s).each{ |m|
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
		
		html="<div class=\"hidden_fields hidden\">".html_safe
		hf=HiddenField.find(:all)
		hf.each{|f|
				if ((f.role_id & ar) != [] or f.role_id.include?("0") )
					if(f.no_role_id.include?("nothing") || ((!f.no_role_id.include?("nothing")) && f.no_role_id.include?("0") && (ar.size==1)) || ((!f.no_role_id.include?("nothing")) && (!f.no_role_id.include?("0")) && ((f.no_role_id & ar)==[])) ) #Check that role is not
						html+="<div class=\"item\">".html_safe
						if !f.issue_field.include?("nothing")
							if f.issue_field.include?("0")
								html+="<div class=\"fields\">#{Issue.get_issue_fields.map{|a| a[1]}.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"fields\">#{f.issue_field.uniq.join(", ")}</div>".html_safe
							end			
						end
						if !f.custom_field_id.include?("nothing")
							if f.custom_field_id.include?("0")
								html+="<div class=\"c_fields\">#{all_c_fields.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"c_fields\">#{f.custom_field_id.map{|e| "issue_custom_field_values_"+e.to_s}.uniq.join(", ")}</div>".html_safe
							end	
						end
						html+="<div class=\"all_form\">issue-form</div>".html_safe if f.all_form
						html+="<div class=\"status_id\">#{f.status_id.uniq.join(", ")}</div>".html_safe
						html+="<div class=\"tracker_id\">#{f.tracker_id.uniq.join(", ")}</div>".html_safe	

						html+="</div>".html_safe
					end
				end
			}
		html+="</div>".html_safe
		
		html+="<div class=\"disabled_fields hidden\">".html_safe
		df=DisabledField.find(:all)
		df.each{|f|
				if ((f.role_id & ar) != [] or f.role_id.include?("0") ) #Check that role is
					if(f.no_role_id.include?("nothing") || ((!f.no_role_id.include?("nothing")) && f.no_role_id.include?("0") && (ar.size==1)) || ((!f.no_role_id.include?("nothing")) && (!f.no_role_id.include?("0")) && ((f.no_role_id & ar)==[])) ) #Check that role is not
						html+="<div class=\"item\">".html_safe
						if !f.issue_field.include?("nothing")
							if f.issue_field.include?("0")
								html+="<div class=\"fields\">#{Issue.get_issue_fields.map{|a| a[1]}.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"fields\">#{f.issue_field.uniq.join(", ")}</div>".html_safe
							end			
						end
						if !f.custom_field_id.include?("nothing")
							if f.custom_field_id.include?("0")
								html+="<div class=\"c_fields\">#{all_c_fields.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"c_fields\">#{f.custom_field_id.map{|e| "issue_custom_field_values_"+e.to_s}.uniq.join(", ")}</div>".html_safe
							end	
						end
						html+="<div class=\"all_form\">issue-form</div>".html_safe if f.all_form
						html+="<div class=\"status_id\">#{f.status_id.uniq.join(", ")}</div>".html_safe
						html+="<div class=\"tracker_id\">#{f.tracker_id.uniq.join(", ")}</div>".html_safe	

						html+="</div>".html_safe
					end
				end
			}
		html+="</div>".html_safe		
		
		html+="<div class=\"required_fields hidden\">".html_safe
		rf=RequiredField.find(:all)
		rf.each{|f|
				if ((f.role_id & ar) != [] or f.role_id.include?("0") )
					if(f.no_role_id.include?("nothing") || ((!f.no_role_id.include?("nothing")) && f.no_role_id.include?("0") && (ar.size==1)) || ((!f.no_role_id.include?("nothing")) && (!f.no_role_id.include?("0")) && ((f.no_role_id & ar)==[])) ) #Check that role is not
						html+="<div class=\"item\">".html_safe
						if !f.issue_field.include?("nothing")
							if f.issue_field.include?("0")
								html+="<div class=\"fields\">#{Issue.get_issue_fields.map{|a| a[1]}.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"fields\">#{f.issue_field.uniq.join(", ")}</div>".html_safe
							end			
						end
						if !f.custom_field_id.include?("nothing")
							if f.custom_field_id.include?("0")
								html+="<div class=\"c_fields\">#{all_c_fields.uniq.join(", ")}</div>".html_safe
							else
								html+="<div class=\"c_fields\">#{f.custom_field_id.map{|e| "issue_custom_field_values_"+e.to_s}.uniq.join(", ")}</div>".html_safe
							end	
						end
						#html+="<div class=\"all_form\">issue-form</div>" if f.all_form
						html+="<div class=\"status_id\">#{f.status_id.uniq.join(", ")}</div>".html_safe
						html+="<div class=\"tracker_id\">#{f.tracker_id.uniq.join(", ")}</div>".html_safe	

						html+="</div>".html_safe
					end
				end
			}
		html+="</div>".html_safe

		trackers=[]
		html+="<div class=\"hidden_trackers hidden\">".html_safe
		tf=TrackerRole.find(:all)
		tf.each{|f|
				if (((f.role_id & ar) != [] or f.role_id.include?("0")) and (f.project_id.include?(issue.project.id.to_s) or f.project_id.include?("0")))
					trackers.push(f.tracker_id)
				end
				}
		html+=trackers.flatten.uniq.join(", ").html_safe
		html+="</div><div id=\"current_tracker_id\" class=\"hidden\">#{issue.tracker_id}</div>".html_safe		

	
		html
	end	
  end
  
  module InstanceMethods
    # Methods to add to specific issue objects
	
  end
end

