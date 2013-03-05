class AdminController < ApplicationController
  before_filter :login_required, :except => ['login']
  before_filter :admin_required, :except => ['login']
  
  def login
    
  end
  
  def index
    @user_count = User.all.count
    @trans_count= Transaction.all.count
    @balance    = Account.sum(:balance)
    #@balance = 999.99
    #@trans_sum  = Transaction.average(:credit) * 2
    @trans_sum = 999.99
  end
  
  def users
    if @current_user.role.name == 'Company Admin'
      @users = User.find(:all, :conditions => ["(country_id = :c and role_id='5') or company_id = :cid", {:c => @current_user.country_id, :cid => @current_user.company_id}], :include => [:user_phones])
    elsif @current_user.role.name == 'Company Staff'
      @users = User.find(:all, :conditions => ["country_id = :c and company_id = :cid", {:c => @current_user.country_id, :cid => @current_user.company_id}], :include => [:user_phones])
    elsif @current_user.role.name == 'SM Super Admin' or @current_user.role.name == 'SM Admin'
      @users = User.find(:all, :conditions => ["country_id = :c", {:c => @current_user.country_id}], :include => [:user_phones])
    else
      @users = User.find(:all, :include => [:user_phones])
    end
  end

  def transactions
    @transactions = Transaction.find(:all, :conditions => [" (account_id=? or ?<300)", @current_user.account.id,  @current_user.role.code], :order => "created_at ASC")
  end

  def issue_emoney
  
    phone  = request.params['phone_number_to']
    @phone_number_to  = request.params['phone_number_to']
    amount = request.params['amount']
 
    unless request.params['hdn']
	render :action => 'issue_emoney' and return
    end

    
    unless UserPhone.phone_number_valid?(phone)
      @message = "Invalid Phone Number"
      render :action => 'issue_emoney' and return
    end
    
      if request.params['amount'].nil?
      @message = "Invalid Amount"
         render :action => 'issue_emoney' and return
      end
   
      user_to = UserPhone.find_user(phone)
  
      
      Transaction.transaction do
	Transaction.credit(user_to.id, phone, user_to.account.id, current_user.id, '', '', amount , 'cashin-credit')
	User.add_balance(user_to.id,amount.to_s)
      end    
      
      #send USSD notification
      @h = {}
      ph = UserPhone.find_by_phone_number(phone)
      @int = Interface.find(:all, :conditions => {:screen => 'CASHIN', :language => ph.user.language})
      @int.each do |r|
	@h[r.element] = r.text
      end

      am = format( "%.2f", amount.to_f() )
      @sms_msg = URI.escape("#{am} #{@h['CASHIN_SUCCEEDED']} #{@h['CASHIN_NEWBALANCE']} #{ph.user.account.balance}")
      
      send_sms(phone,@sms_msg)
      #send_ussd(phone,@sms_msg)
    
    redirect_to admin_status_url, :notice => "Issue e-money operation completed!" 
      
      
  end
  
  def cancel_emoney

    amount = request.params['amount']
        
    unless request.params['hdn']
	render :action => 'cancel_emoney' and return
    end
  
    unless request.params['amount'].to_f > 0
    @message = "Invalid Amount"
	render :action => 'cancel_emoney' and return
    end
    
    acc = Account.find_by_id(params[:account][:account_id])
    unless acc
      @message = "Invalid Account"
      render :action => 'cancel_emoney' and return
    end
    
    uf = UserPhone.find_by_user_id(current_user.id)
    phone = uf.phone_number
      
    Transaction.transaction do
      Transaction.debit(current_user.id, phone, acc.id, '0', '', '', amount , 'cashout-debit')
      Account.deduct_balance(acc.id,amount.to_s)
    end    
      
    
    redirect_to admin_status_url, :notice => "Cancel e-money operation completed!" 
    
    
  end
  
  
  def send_sms(to_phone, msg)
        require "httparty"
        response = HTTParty.get("http://www.sms.co.tz/api.php?do=sms&username=[user]&password=[pass]&senderid=SlickMoney&dest=#{to_phone}&msg=#{msg}")
  end
  
  def send_ussd(to_phone, msg)
        require "httparty"
        response = HTTParty.get("http://ec2.globalussd.mobi/push?service=smart.push&subscriber=#{to_phone}&message=#{@msg}")
  end

end
