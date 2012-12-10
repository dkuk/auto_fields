require_dependency 'auto_fields_controller'
require_dependency 'disabled_fields_controller'
require_dependency 'hidden_fields_controller'
require_dependency 'required_fields_controller'
require_dependency 'tracker_roles_controller'

class AutoFieldsController < ApplicationController
  unloadable

  before_filter :get_select_box_data_for_auto_fields_plugin, :require_admin
  
  def index
	@auto_field= AutoField.new;
  end
  
  def edit
	@auto_field=AutoField.find(params[:id])
  end  

  def update
	@auto_field = AutoField.find(params[:id])
	if 	@auto_field.update_attributes(params[:auto_field])
		redirect_to :action => 'index' 	
	else
		render :action => "edit"	
	end  
  end   
  
  def create
	@auto_field = AutoField.new(params[:auto_field])
	
	if @auto_field.save
		flash[:notice] = l(:auto_field_create_apply)
		redirect_to :action => 'index' 
	else	
		render :action => "index"
	end 	
  end
  
  
  def destroy
  @auto_field = AutoField.find(params[:id])
  @auto_field.destroy
  flash[:notice] = l(:auto_field_delete_mess)
  redirect_to :action => 'index' 
  end  

  def update_all
 
  flash[:notice]=l(:auto_field_edit_mess)
  patterns = { 1 => { "pattern" => "David" }, 2 => { "pattern" => "Jeremy" } }
  AutoField.update(params[:auto_fields_values].keys, params[:auto_fields_values].values);
  redirect_to :action => 'index' 
  end    
  
end

