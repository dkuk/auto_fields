class CreateRequiredFields < ActiveRecord::Migration
  def self.up
    create_table :required_fields do |t|
    t.text :tracker_id
	t.text :status_id
	t.text :role_id
	t.text :custom_field_id	
	t.text :issue_field
	t.timestamps		
    end
  end

  def self.down
    drop_table :required_fields
  end
end
