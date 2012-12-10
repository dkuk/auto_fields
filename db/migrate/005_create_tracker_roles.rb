class CreateTrackerRoles < ActiveRecord::Migration
  def self.up
    create_table :tracker_roles do |t|
		t.text :tracker_id
		t.text :role_id
		t.text :project_id
		t.timestamps
    end
  end

  def self.down
    drop_table :tracker_roles
  end
end
