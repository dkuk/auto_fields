class ChangeAutoFields < ActiveRecord::Migration
  def self.up
	change_table :auto_fields do |t|
	  t.remove :status_id
	  t.remove :tracker_id
	  t.text :current_status_id
	  t.text :updated_status_id
	  t.text :tracker_id
	  t.text :role_id
	  t.string :issue_field
	end
  end

  def self.down
	change_table :auto_fields do |t|  
	  t.remove :current_status_id
	  t.remove :updated_status_id 
	  t.remove :tracker_id
	  t.remove :role_id
	  t.remove :issue_field
      t.references :tracker
	  t.references :status
	end
  end

end