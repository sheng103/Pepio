class CountriesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  def index
    @countries = Country.all
  end
  
  def show
    @country = Country.find_by_id(params[:id])
  end
  
  def new
    @country = Country.new
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:notice] = "Successfully added country."
      redirect_to @country
    else
      flash[:error] = "Unable to create country. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @country = Country.find_by_id(params[:id])
  end
  
  def update
    @country = Country.find_by_id(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = "Successfully edited country."
      redirect_to country_url(@country)
    else
      flash[:error] = "Unable to update country. Please check your entries"
      render :action => 'edit'
    end
  end
  
  #def destroy
  #  @country = Country.find_by_id(params[:id])
  #  if @country.destroy
  #    flash[:notice] = "Successfully deleted country."
  #  else
  #    flash[:error] = "Error in deleting country."
  #  end
  #  redirect_to countries_url
  #end
  
  def delete
    @country = Country.find_by_id(params[:id])
    @country.mark_as_deleted
    if @country.save
      flash[:notice] = "Successfully deleted country."
    else
      flash[:error] = "Error in deleting country."
    end
    redirect_to countries_url
  end
end
