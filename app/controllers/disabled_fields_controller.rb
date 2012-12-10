require_dependency 'auto_fields_controller'
require_dependency 'disabled_fields_controller'
require_dependency 'hidden_fields_controller'
require_dependency 'required_fields_controller'
require_dependency 'tracker_roles_controller'

class DisabledFieldsController < ApplicationController
  unloadable
  
   before_filter :get_select_box_data_for_auto_fields_plugin, :require_admin, :except => [:update]
   
  def index
	params[:tab]="disabled_fields"
	@disabled_field= DisabledField.new;
  end 
  
  def edit
	@disabled_field=DisabledField.find(params[:id])
  end  
  
  def update
	@disabled_field = DisabledField.find(params[:id])
	if 	@disabled_field.update_attributes(params[:disabled_field])
		redirect_to :action => 'index' 	
	else
		render :action => "edit"	
	end  
  end  
  
  def create
	params[:tab]="disabled_fields"
	@disabled_field=DisabledField.new(params[:disabled_field])
	if @disabled_field.save
		flash[:notice] = l(:disabled_field_create_apply)
		redirect_to :action => 'index' 
	else	
		render :action => "index"
	end
  end    
  
  def destroy
  @disabled_field = DisabledField.find(params[:id])
  @disabled_field.destroy
  flash[:notice] = l(:disabled_field_delete_mess)
  redirect_to :action => 'index' 
  end    
end
  