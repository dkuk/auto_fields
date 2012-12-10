class AddNoRewrite < ActiveRecord::Migration
  def self.up
	change_table :auto_fields do |t|
		t.boolean :no_rewrite, :default => false
	end
  end

  def self.down
	change_table :auto_fields do |t|  
	  t.remove :no_rewrite
	end
  end

end