class RequiredField < ActiveRecord::Base
  unloadable
  serialize :tracker_id
  serialize :status_id
  serialize :role_id
  serialize :custom_field_id
  serialize :issue_field
  serialize :no_role_id
end
