
module AutoFieldsApplicationControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
    end

  end

  module ClassMethods   
    # Methods to add to the Issue class
  end

  module InstanceMethods
    # Methods to add to specific issue objects
	  def get_select_box_data_for_auto_fields_plugin
		#@custom_field=CustomField.find(:all, :conditions => { :field_format =>["user"], :type=>"IssueCustomField"},  :order => "name ASC")
		@hidden_field = HiddenField.new;
		@auto_field = AutoField.new;
		@disabled_field = DisabledField.new;
		@tracker_role = TrackerRole.new;
		@required_field = RequiredField.new;
		
		@trackers=Tracker.find(:all, :order => "name ASC")
		@statuses=IssueStatus.find(:all, :order => "name ASC")
		@roles=Role.find(:all, :order => "name ASC")
		@auto_fields=AutoField.find(:all, :order => "custom_fields.name ASC", :include => [:custom_field]) #
		@hidden_fields=HiddenField.find(:all)
		@disabled_fields=DisabledField.find(:all)
		@required_fields=RequiredField.find(:all)
		@custom_fields=CustomField.find(:all, :order => "name ASC", :conditions=>"type='IssueCustomField'")
		@issue_fields=Issue.get_issue_fields
		@issue_fields_available_for_hidden=Issue.get_issue_fields_available_for_hidden
		@issue_fields_for_required=Issue.get_issue_fields_available_for_required
		@tracker_roles=TrackerRole.find(:all)
		@projects=Project.find(:all)
		#@AF=AutoField.new
		
		@all_issue_fields=Issue.get_all_issue_fields
	 end 		
  end
end

