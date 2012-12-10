
module AutoFieldsIssuesControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
		alias_method_chain :build_new_issue_from_params, :auto_fields if(Setting.plugin_auto_fields['enable'] == 'true')
		alias_method_chain :new, :auto_fields if(Setting.plugin_auto_fields['enable'] == 'true')
    end

  end

  module ClassMethods   
    # Methods to add to the Issue class
  end

  module InstanceMethods
    # Methods to add to specific issue objects
	def build_new_issue_from_params_with_auto_fields
		build_new_issue_from_params_without_auto_fields
		av_trackers=@issue.get_available_issue_trackers
		if(! av_trackers.include?(@issue.tracker.id.to_s))
			@issue.tracker = Tracker.find(:first, :conditions => [ "id IN (?)", av_trackers], :order => "position")	
		end
		if @issue.tracker.nil? || av_trackers == []
			render_error l(:error_no_tracker_in_project)
		    return false
		end			
	end
	
	def new_with_auto_fields
	    respond_to do |format|
	      format.html { render :action => 'new', :layout => !request.xhr? }
	      format.js {
	        render(:update) { |page|
	          if params[:project_change]
	            page.replace_html 'all_attributes', :partial => 'form'
	          else
	            page.replace_html 'attributes', :partial => 'attributes'
	          end
	          m = User.current.allowed_to?(:log_time, @issue.project) ? 'show' : 'hide'
	          page << "if ($('log_time')) {Element.#{m}('log_time');}"
	          page << " hide_issue_fields(true); disable_issue_fields(); require_issue_fields();"	
	        }
	      }
	    end
	end	
  end
end

