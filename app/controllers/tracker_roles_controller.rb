require_dependency 'auto_fields_controller'
require_dependency 'disabled_fields_controller'
require_dependency 'hidden_fields_controller'
require_dependency 'required_fields_controller'
require_dependency 'tracker_roles_controller'

class TrackerRolesController < ApplicationController
  unloadable

  before_filter :get_select_box_data_for_auto_fields_plugin, :require_admin
  before_filter :get_tab
  
  def index
	@tracker_role= TrackerRole.new;
  end 

  def edit
	@tracker_role=TrackerRole.find(params[:id])
  end  
  
  def update
	@tracker_role = TrackerRole.find(params[:id])
	if 	@tracker_role.update_attributes(params[:tracker_role])
		redirect_to :action => 'index' 	
	else
		render :action => "edit"	
	end  
  end  
  
  def create
	@tracker_role=TrackerRole.new(params[:tracker_role])
	if @tracker_role.save
		flash[:notice] = l(:tracker_role_create_apply)
		redirect_to :action => 'index' 
	else	
		render :action => "index"
	end
  end    
  
  def destroy
	  @tracker_role = TrackerRole.find(params[:id])
	  @tracker_role.destroy
	  flash[:notice] = l(:tracker_role_delete_mess)
	  redirect_to :action => 'index' 
  end   
  
  private
  def get_tab
	params[:tab]="tracker_roles"
  end   
  
end
