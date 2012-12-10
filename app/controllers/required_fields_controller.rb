require_dependency 'auto_fields_controller'
require_dependency 'disabled_fields_controller'
require_dependency 'hidden_fields_controller'
require_dependency 'required_fields_controller'
require_dependency 'tracker_roles_controller'

class RequiredFieldsController < ApplicationController
  unloadable
  
   before_filter :get_select_box_data_for_auto_fields_plugin, :require_admin
   
  def index
	params[:tab]="required_fields"
	@required_field= RequiredField.new;
  end 

  def edit
	@required_field=RequiredField.find(params[:id])
  end  
  
  def update
	@required_field = RequiredField.find(params[:id])
	if 	@required_field.update_attributes(params[:required_field])
		redirect_to :action => 'index' 	
	else
		render :action => "edit"	
	end  
  end  
  
  def create
	params[:tab]="required_fields"
	@required_field=RequiredField.new(params[:required_field])
	if @required_field.save
		flash[:notice] = l(:required_field_create_apply)
		redirect_to :action => 'index' 
	else	
		render :action => "index"
	end
  end    
  
  def destroy
  @required_field = RequiredField.find(params[:id])
  @required_field.destroy
  flash[:notice] = l(:required_field_delete_mess)
  redirect_to :action => 'index' 
  end    
end