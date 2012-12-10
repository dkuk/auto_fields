class AddFieldNoRole < ActiveRecord::Migration
  def self.up
    add_column :disabled_fields, :no_role_id, :text
  end

  def self.down
    remove_column :disabled_fields, :no_role_id 
  end

end