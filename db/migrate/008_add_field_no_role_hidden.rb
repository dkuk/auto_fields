class AddFieldNoRoleHidden < ActiveRecord::Migration
  def self.up
    add_column :hidden_fields, :no_role_id, :text
  end

  def self.down
    remove_column :hidden_fields, :no_role_id 
  end

end