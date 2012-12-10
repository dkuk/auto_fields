class AddFieldNoRoleRequired < ActiveRecord::Migration
  def self.up
    add_column :required_fields, :no_role_id, :text
  end

  def self.down
    remove_column :required_fields, :no_role_id 
  end

end