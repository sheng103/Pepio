class AccountsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
 
  
  def index
    @accounts = Account.all
  end
  
  def show
    @account = Account.find_by_id(params[:id])
  end
  
  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Successfully added account."
      redirect_to @account
    else
      flash[:error] = "Unable to create account. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @account = Account.find_by_id(params[:id])
  end
  
  def update
    @account = Account.find_by_id(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = "Successfully edited account."
      redirect_to account_url(@account)
    else
      flash[:error] = "Unable to update account. Please check your entries"
      render :action => 'edit'
    end
  end
  
  #def destroy
  #  @account = Account.find_by_id(params[:id])
  #  if @account.destroy
  #    flash[:notice] = "Successfully deleted account."
  #  else
  #    flash[:error] = "Error in deleting account."
  #  end
  #  redirect_to accounts_url
  #end
  
  def delete
    @account = Account.find_by_id(params[:id])
    @account.mark_as_deleted
    if @account.save
      flash[:notice] = "Successfully deleted account."
    else
      flash[:error] = "Error in deleting account."
    end
    redirect_to accounts_url
  end
  

  
end
