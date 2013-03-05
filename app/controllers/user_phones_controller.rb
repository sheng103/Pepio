class UserPhonesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  
  def create
    user = User.find_by_id(params[:user_id])
        
    prefix = $country_code[user.country.id.to_s]
    uphone = params[:phone_number]
    uphone.gsub!(/^0/, prefix)
    
    user.user_phones << UserPhone.new(:phone_number => uphone.to_i)
    if user.save
      flash[:notice] = "Phone number added."
      
    else
      flash[:error] = "Error in adding phone number."
    end
    redirect_to user_url(user)
  end
  
  def destroy
    user = User.find_by_id(params[:user_id])
    phone = user.user_phones.find(params[:phone_id])
    if phone.destroy
      flash[:notice] = "Successfully deleted phone number."
    else
      flash[:error] = "Error in deleting phone number."
    end
    redirect_to user_url(user)
  end
end
