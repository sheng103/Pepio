class UsersController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  
  def new  
    @user = User.new  
  end  
    
  def create  
    @role = Role.find_by_id(params[:user][:role_id])
 
    if @role.nil?
      @user = User.new
      flash[:error] = "Please, choose role"
      render "new"
      return
    end
    
    if  @current_user.role.code >= @role.code
      @user = User.new
      flash[:error] = "Unable to create user of that role. Insufficient privileges #{@current_user.role.code} - #{params[:user][:role_id]}"
      render "new"
      return
   end      
    
    if @role.name == 'SM Super Admin' or @role.name == 'SM Admin'
      @account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM CashOut", :c => params[:user][:country_id] }])
      params[:user][:company_id] = @current_user.company.id  
    end
    
    if @role.name == 'Company Admin'
      @account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c and company_id=:co", { :t => "Company", :c => params[:user][:country_id], :co=>params[:user][:company_id]  }])
    end
    
    
    if @role.name == 'Company Staff'
      if @current_user.role.name == "SM Admin" or @current_user.role.name == "SM Staff"
      @account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c and company_id=:co", { :t => "Company", :c => params[:user][:country_id], :co=>params[:user][:company_id]  }])
      else
      Rails.logger.info("Current user company ID: #{@current_user.company.id}")    
      @account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c and company_id=:co", { :t => "Company", :c => params[:user][:country_id], :co=>@current_user.company.id  }])
      params[:user][:company_id] = @current_user.company.id  
      end
    end
    
    if @role.name == 'User'
      @floatacc = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM CashOut", :c => params[:user][:country_id] }])
      params[:user][:company_id] = @floatacc.company.id  
      @account = Account.new(:name => "#{params[:user][:first_name]} #{params[:user][:surname]} acc.", :account_type => 'User', :country_id => params[:user][:country_id], :company_id => @floatacc.company.id, :created_by_user_id => @current_user.id)
      @account.save   
    end
    
    @user = User.new(params[:user])  
    @user.created_by_user_id = current_user.id if !current_user.nil?
    @user.account_id = @account.id
    
    
    prefix = $country_code[params[:user][:country_id]]
    uphone = params[:phone_number]
    uphone.gsub!(/^0/, prefix)
    
    ph = UserPhone.find_by_phone_number(uphone.to_i)
    if ph
      flash[:error] = "Invalid phone number"
      render "new"
      return
    end
    
    phone = UserPhone.new(:phone_number => uphone.to_i)
    
    @user.user_phones << phone
    if @user.save
      redirect_to admin_users_url, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end
  
  def show
    @user = User.find_by_id(params[:id], :include => [:user_phones])
  end
  
  def edit
    @user = User.find_by_id(params[:id])
  end
  
  def update
    
    @user = User.find_by_id(params[:id])
    if @current_user.role.code >= @user.role.code
      flash[:error] = "Unable to update user. Insufficient privileges"
      render :action => 'edit'
      return
    end      
    @user.updated_by_user_id = current_user.id if !current_user.nil?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully edited user."
      redirect_to user_url(@user)
    else
      flash[:error] = "Unable to update user. Please check your entries"
      render :action => 'edit'
    end
  end
  
  def delete
    @user = User.find_by_id(params[:id])
    if @current_user.role.code >= @user.role.code
      flash[:error] = "Unable to delete user. Insufficient privileges"
      redirect_to admin_users_url
      return
    end      

    @user.mark_as_deleted

    if @user.save
      phone = @user.user_phones.find_by_user_id(params[:id])
      phone.destroy
      flash[:notice] = "Successfully deleted user."
    else
      flash[:error] = "Error in deleting user."
    end
    redirect_to admin_users_url
  end
  
  def user_phones
    return unless request.post?
    @user = User.find_by_id(params[:user_id])
    phone = UserPhone.create(:phone_number => params[:phone_number], :user_id => params[:user_id])
    if phone.save
      flash[:notice] = "Successfully added phone number"
      redirect_to user_url(@user)
    else
      flash[:error] = "Unable to add phone number"
      render :action => 'show'
    end
  end
  
  def delete_user_phones
    
  end
end
