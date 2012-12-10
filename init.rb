require 'redmine'
=begin
require_dependency 'auto_fields_issue_patch'
require_dependency 'auto_fields_tracker_patch'
require_dependency 'auto_fields_custom_field_patch'
require_dependency 'auto_fields_issue_status_patch'
require_dependency 'auto_fields_issues_helper_patch'
=end

Redmine::Plugin.register :auto_fields do
	name 'Redmine Auto Fields plugin'
	author 'Pitin Vladimir Vladimirovich'
	description 'This plugin enables: task fields hiding or locking, automatic task field filling on task update, flexible tracker customization.'
	version '0.0.2'
	url 'http://pitin.su'
	author_url 'http://pitin.su'

	settings	:partial => 'settings/redmine_auto_fields_settings',
				:default => {"statement_accounting_ad_group" => "0"}		
	menu :admin_menu, :admin_menu_auto_fields, { :controller => 'auto_fields', :action => 'index'}, :caption => :admin_menu_auto_fields	

end

Rails.application.config.to_prepare do
  Issue.send(:include, AutoFieldsIssuePatch)
  Tracker.send(:include, AutoFieldsTrackerPatch)
  CustomField.send(:include, AutoFieldsCustomFieldPatch)
  IssueStatus.send(:include, AutoFieldsIssueStatusPatch)
  IssuesHelper.send(:include, AutoFieldsIssuesHelperPatch)
  IssuesController.send(:include, AutoFieldsIssuesControllerPatch)
  ApplicationController.send(:include, AutoFieldsApplicationControllerPatch)
end

require 'hooks/auto_fields_views_issues_hook'


