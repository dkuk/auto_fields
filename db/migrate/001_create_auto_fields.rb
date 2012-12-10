class CreateAutoFields < ActiveRecord::Migration
  def self.up
    create_table :auto_fields do |t|
      t.references :custom_field
      t.references :tracker
	  t.references :status
	  t.string :pattern
      t.timestamps
	  
    end
  end

  def self.down
    drop_table :auto_fields
  end
end
