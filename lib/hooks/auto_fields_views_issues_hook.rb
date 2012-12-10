module RedmineAutoFields
  module Hooks
    class AutoFieldsViewsIssuesHook < Redmine::Hook::ViewListener     
		render_on :view_issues_form_details_top, :partial => 'issues/hidden_issue_fields', :layout => false
		render_on :view_layouts_base_html_head, :partial => 'hooks/auto_fields/add_css', :layout => false
    end
  end
end