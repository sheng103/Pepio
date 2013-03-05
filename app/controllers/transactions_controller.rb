class TransactionsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => [:new,:create,:edit,:update,:delete,:search]
  
  def index
  end

  def show
    @transaction = Transaction.find_by_id(params[:id])
  end
  
  def new
    @transaction = Transaction.new
  end
  
  def create
     @transaction = Transaction.new(params[:transaction])
    if @transaction.save
      flash[:notice] = "Successfully added transaction."
      redirect_to @transaction
    else
      flash[:error] = "Unable to create transaction. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @transaction = Transaction.find_by_id(params[:id])
  end
  
  def update
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.updated_by_user_id = current_user.id
    
    if @transaction.update_attributes(params[:transaction])
      flash[:notice] = "Successfully edited transaction."
      redirect_to transaction_url(@transaction)
    else
      flash[:error] = "Unable to update transaction. Please check your entries"
      render :action => 'edit'
    end
  end
  
  def balance
 #REALP
      Rails.logger.info("PARAMS: #{params.inspect}")
      Rails.logger.info("cookies: #{cookies.inspect}")
      Rails.logger.info("REQ cookies: #{request.cookies.inspect}")

    @balance = current_user.account.balance
  end
  
  def transfer
    if request.post?
      phone  = params[:phone_number]
      amount = params[:amount]
      balance= current_user.account.balance
      
      if check_invalid_phone_number(phone) == false
        redirect_to transaction_messages_url(:error => "unknown phone number") and return
      end
      
      if check_sufficient_funds(amount) == false
        redirect_to transaction_messages_url(:error => "insufficient funds", :balance => balance) and return
      end
      
      phone_fr=session[:phone_no] #current_user.phone_numbers
      user_to =transfer_to(phone)
      
        Transaction.transaction do
          Transaction.debit(current_user.id, phone_fr, phone,user_to.id,amount ,'transfer-from')
          Transaction.debit(current_user.id, phone_fr, phone, $SM_ACCOUNT,amount.to_f*$FEE ,'transferfee-debit')
          Transaction.credit(current_user.id, phone_fr, phone,user_to.id,amount , 'transfer-to')
          Transaction.credit(current_user.id, phone_fr, phone,$SM_ACCOUNT,amount.to_f*$FEE , 'transferfee-credit')
          User.deduct_balance(current_user.id,amount.to_f+amount.to_f*$FEE)
          User.add_balance(user_to.id,amount)
          User.add_balance($SM_ACCOUNT,amount.to_f*$FEE)
        end

      
      flash[:notice] = "You have successfully transferred #{amount} to #{user_to.surname} at #{phone}"
      redirect_to balance_url
    end
  end
  
  def messages
    case params[:error]
      when "unknown phone number"
        @message = "Unknown phone number. If this phone number is correct, please have the owner of this phone register to SlickMoney at the nearest  SlickMoney agent."
      when "insufficient funds"
        @message = "Amount is more than your balance of #{params[:balance]}."
    end
  end
  
  def search
    clause = []

    if !params[:date].blank?
      clause << " DATE(created_at) = '#{params[:date]}' "
    end
    
    if !params[:debit].blank?
      clause << " debit = #{params[:debit]} "
    end
    
    if !params[:credit].blank?
      clause << " credit = #{params[:credit]} "
    end
    
    if !params[:type].blank?
      clause <<  " transaction_type = '#{params[:type]}' "
    end
    
    if !params[:user_id].blank?
      clause << " user_id = #{params[:user_id]} "
    end
    
    if !params[:phone_no].blank?
      clause << " phone_number = #{params[:phone_no]} "
    end
    
    if !params[:counter_user_id].blank?
      clause << " counter_user_id = #{params[:counter_user_id]} "
    end
    
    if !params[:counter_phone_number].blank?
      clause << " counter_phone_number = #{params[:counter_phone_number]} "
    end
    
    clause = clause.join(' and ')
    
    @transactions = Transaction.find(:all, :conditions => clause)
  end
  
  private 
  
  def process_transaction
    
  end
  
  def check_invalid_phone_number(phone)
    UserPhone.phone_number_valid?(phone)
  end
  
  def check_sufficient_funds(amount)
    return true if current_user.account.balance >= BigDecimal.new(amount)
    return false
  end
  
  def transfer_to(phone)
    UserPhone.find_user(phone) 
  end
  
end
