class TrackerRole < ActiveRecord::Base
  unloadable
  serialize :tracker_id
  serialize :role_id
  serialize :project_id
end
