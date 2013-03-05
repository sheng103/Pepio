class CompaniesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  def index
    @companies = Company.all
  end
  
  def show
    @company = Company.find_by_id(params[:id])
  end
  
  def new
    @company = Company.new
  end
  
  def create

    @company = Company.new(params[:company])
    account = Account.new(:name => "#{params[:company][:name]}", :account_type => 'Company', :country_id => params[:company][:country_id], :company_id => 0, :created_by_user_id => @current_user.id)
    @company.account = account.id
    @company.created_by_user_id = current_user.id if !current_user.nil?
    if @company.save
      account.company_id = @company.id
      account.save
      flash[:notice] = "Successfully added company."
      redirect_to @company
    else
      flash[:error] = "Unable to create company. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @company = Company.find_by_id(params[:id])
  end
  
  def update
    @company = Company.find_by_id(params[:id])
    if @company.update_attributes(params[:company])
      flash[:notice] = "Successfully edited company."
      redirect_to company_url(@company)
    else
      flash[:error] = "Unable to update company. Please check your entries"
      render :action => 'edit'
    end
  end
  
  #def destroy
  #  @company = Company.find_by_id(params[:id])
  #  if @company.destroy
  #    flash[:notice] = "Successfully deleted company."
  #  else
  #    flash[:error] = "Error in deleting company."
  #  end
  #  redirect_to companies_url
  #end
  
  def delete
    @company = Company.find_by_id(params[:id])
    @company.mark_as_deleted
    if @company.save
      flash[:notice] = "Successfully deleted company."
    else
      flash[:error] = "Error in deleting company."
    end
    redirect_to companies_url
  end
end
