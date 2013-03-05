class InterfacesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  def index
    @interfaces = Interface.all
  end
  
  def show
    @interface = Interface.find_by_id(params[:id])
  end
  
  def new
    @interface = Interface.new
  end
  
  def create
    @interface = Interface.new(params[:interface])
    if @interface.save
      flash[:notice] = "Successfully added interface."
      redirect_to @interface
    else
      flash[:error] = "Unable to create interface. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @interface = Interface.find_by_id(params[:id])
  end
  
  def update
    @interface = Interface.find_by_id(params[:id])
    if @interface.update_attributes(params[:interface])
      flash[:notice] = "Successfully edited interface."
      redirect_to interface_url(@interface)
    else
      flash[:error] = "Unable to update interface. Please check your entries"
      render :action => 'edit'
    end
  end
  
  #def destroy
  #  @interface = Interface.find_by_id(params[:id])
  #  if @interface.destroy
  #    flash[:notice] = "Successfully deleted interface."
  #  else
  #    flash[:error] = "Error in deleting interface."
  #  end
  #  redirect_to interfaces_url
  #end
  
  def delete
    @interface = Interface.find_by_id(params[:id])
    @interface.mark_as_deleted
    if @interface.save
      flash[:notice] = "Successfully deleted interface."
    else
      flash[:error] = "Error in deleting interface."
    end
    redirect_to interfaces_url
  end
end
