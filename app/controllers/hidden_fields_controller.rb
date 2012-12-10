require_dependency 'auto_fields_controller'
require_dependency 'disabled_fields_controller'
require_dependency 'hidden_fields_controller'
require_dependency 'required_fields_controller'
require_dependency 'tracker_roles_controller'

class HiddenFieldsController < ApplicationController
	unloadable
	before_filter :get_select_box_data_for_auto_fields_plugin, :require_admin
   
	def index
		params[:tab]="hidden_fields"
		@hidden_field= HiddenField.new;
	end 
  
  def edit
	@hidden_field=HiddenField.find(params[:id])
  end  
  
  def update
	@hidden_field = HiddenField.find(params[:id])
	if 	@hidden_field.update_attributes(params[:hidden_field])
		redirect_to :action => 'index' 	
	else
		render :action => "edit"	
	end  
  end    
  
  def create
	params[:tab]="hidden_fields"
	@hidden_field=HiddenField.new(params[:hidden_field])
	if @hidden_field.save
		flash[:notice] = l(:hidden_field_create_apply)
		redirect_to :action => 'index' 
	else	
		render :action => "index"
	end
  end    
  
  def destroy
  @hidden_field = HiddenField.find(params[:id])
  @hidden_field.destroy
  flash[:notice] = l(:hidden_field_delete_mess)
  redirect_to :action => 'index' 
  end    
  
end
