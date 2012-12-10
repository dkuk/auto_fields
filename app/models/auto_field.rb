class AutoField < ActiveRecord::Base
  unloadable
  
  #belongs_to :tracker, :class_name => 'Tracker', :foreign_key => 'tracker_id'
  belongs_to :custom_field, :class_name => 'CustomField', :foreign_key => 'custom_field_id'
  #belongs_to :issue_status, :class_name => 'IssueStatus', :foreign_key => 'status_id'
  serialize :current_status_id
  serialize :updated_status_id
  serialize :role_id
  serialize :tracker_id
  validates_presence_of :custom_field_id
  validates_presence_of :tracker_id
  validates_presence_of :current_status_id
  validates_presence_of :updated_status_id
  #validates_uniqueness_of :custom_field_id, :scope => [:tracker_id, :status_id], :message => l(:auto_fields_uniqueness) 
 	
end
