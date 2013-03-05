class RolesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
 
  
  def index
    @roles = Role.all
  end
  
  def show
    @role = Role.find_by_id(params[:id])
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = "Successfully added role."
      redirect_to @role
    else
      flash[:error] = "Unable to create role. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @role = Role.find_by_id(params[:id])
  end
  
  def update
    @role = Role.find_by_id(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = "Successfully edited role."
      redirect_to role_url(@role)
    else
      flash[:error] = "Unable to update role. Please check your entries"
      render :action => 'edit'
    end
  end
  
  #def destroy
  #  @role = Role.find_by_id(params[:id])
  #  if @role.destroy
  #    flash[:notice] = "Successfully deleted role."
  #  else
  #    flash[:error] = "Error in deleting role."
  #  end
  #  redirect_to roles_url
  #end
  
  def delete
    @role = Role.find_by_id(params[:id])
    @role.mark_as_deleted
    if @role.save
      flash[:notice] = "Successfully deleted role."
    else
      flash[:error] = "Error in deleting role."
    end
    redirect_to roles_url
  end
end