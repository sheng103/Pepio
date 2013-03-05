class LandingPagesController < ApplicationController

  layout "xmllayout"

  def new
      #@xml = Builder::XmlMarkup.new
      #format.xml { params }
      Rails.logger.info("PARAMS: #{params.inspect}")
      Rails.logger.info("cookies: #{cookies.inspect}")
      Rails.logger.info("REQ cookies: #{request.cookies.inspect}")
      @sess_id = request.cookies['_session_id']
      @phone_no = request.params['subscriber']

      response.headers["Content-Type"] = 'text/xml'


   @h = {}

    if current_user
      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

      render :action => 'menu'
    else
      #flash[:error] = "Login failed."
      phone = UserPhone.find_by_phone_number(request.params['subscriber'])
      if phone
       @firstname = phone.user.first_name
      else
       @firstname = ''
      end

      @int = Interface.find(:all, :conditions => {:screen => 'LOGIN', :language => 'English'})  
      @int.each do |r|
        @h[r.element] = r.text
      end

   if phone
      @int = Interface.find(:all, :conditions => {:screen => 'LOGIN', :language => phone.user.language})  
      @int.each do |r|
        @h[r.element] = r.text
      end
   else
      render :action => 'register'     
   end
      render :action => 'login'
    end


  end

  def loginxml
    @sess_id = request.cookies['_session_id']
    @phone_no = request.params['subscriber']
    user = User.authenticate(params[:subscriber], params[:password])
    phone = UserPhone.find_by_phone_number(request.params['subscriber'])

    @h = {}
    if user
      session[:user_id] = user.id
      session[:role_code] = user.role.code
      session[:phone_no]= params[:subscriber]
      #redirect_to new_landing_pages_url, :notice => "Logged in!"
      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

      render :action => 'menu'
    else
      @message = "Login failed";
      @int = Interface.find(:all, :conditions => {:screen => 'LOGIN', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'LOGIN', :language => phone.user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end
      render :action => 'login'
    end
  end

  def balance
      @sess_id = request.cookies['_session_id']
      @balance = current_user.account.balance


      @h = {}
      @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end
      response.headers["Content-Type"] = 'text/xml'

  end

  def transfer
      @sess_id = request.cookies['_session_id']
      @balance = current_user.account.balance
      response.headers["Content-Type"] = 'text/xml'
      @h = {}

      @int = Interface.find(:all, :conditions => {:screen => 'TRANSFER', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'TRANSFER', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

    if request.params['phone_number_to'].nil?
         render :action => 'phone'  and return
    end
	 
      phone  = request.params['phone_number_to']
      @phone_number_to  = request.params['phone_number_to']
      amount = request.params['amount']
      balance= current_user.account.balance

      unless UserPhone.phone_number_valid?(phone)
        #@message = "Invalid Phone Number"
        @message =  "#{request.params['phone_number_to']} #{@h['TRANSFER_ERROR_UNREGISTEREDPHONE']}"
        render :action => 'phone' and return
      end


      if request.params['amount'].nil?
         render :action => 'amount' and return
      end

        #famount = amount.to_f*$FEE 
        phone_fr = session[:phone_no] #current_user.phone_numbers
        user_to = UserPhone.find_user(phone)
      
      commission = 0
      if ((user_to.role.name == 'Company Admin' or user_to.role.name == 'Company Staff') and current_user.role.name='User')
	  ###commission = amount.to_f * $FEE_CASHOUT_COMMISSION
      elsif ((current_user.role.name == 'Company Admin' or current_user.role.name == 'Company Staff') and user_to.role.name='User')
	  commission = amount.to_f * $FEE_CASHIN + amount.to_f*$FEE_CASHIN
      elsif $ENABLE_TRANSFER_FEE == 1
	  commission = amount.to_f * $FEE
      end

	
       total = amount.to_f + commission
        if current_user.account.balance < total
           #@message = "insufficient funds"
           @message = "#{@h['TRANSFER_FAILED']} #{@h['TRANSFER_ERROR_INSUFFICIENTFUNDS']} #{current_user.account.balance}"
          render :action => 'amount' and return
        end


	    
	
	  Transaction.transaction do
	    Transaction.debit(current_user.id, phone_fr, current_user.account.id, user_to.id, phone, user_to.account.id, amount , 'transfer-from')
	    Transaction.credit(user_to.id, phone, user_to.account.id, current_user.id, phone_fr, current_user.account.id, amount , 'transfer-to')
	    
	    User.deduct_balance(current_user.id,amount.to_s)
	    User.add_balance(user_to.id,amount.to_s)
     
	    
	    if ((user_to.role.name == 'Company Admin' or user_to.role.name == 'Company Staff') and current_user.role.name='User')
	        
		Rails.logger.info("Transfer - Cash-out detected")
		commission = amount.to_f * $FEE_CASHOUT_COMMISSION
		comm_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Commissions", :c => current_user.country.id }])
		comm_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => comm_account.id }])

		Transaction.debit( comm_user.id, '', comm_account.id, current_user.id, phone_fr, current_user.account.id, commission , 'commissionpay-debit')
		Transaction.credit(current_user.id, phone_fr, current_user.account.id, comm_user.id, '', comm_account.id, commission , 'commissionpay-credit')
		User.deduct_balance(comm_user.id,commission.to_s)
		User.add_balance(current_user.id,commission.to_s)
	    
	    elsif ((current_user.role.name == 'Company Admin' or current_user.role.name == 'Company Staff') and user_to.role.name='User')
		 
		Rails.logger.info("Transfer - company to user transfer detected")
		commission = amount.to_f * $FEE_CASHIN_COMMISSION
                fee = amount.to_f*$FEE_CASHIN
		comm_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Commissions", :c => current_user.country.id }])
		comm_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => comm_account.id }])
		op_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Operating", :c => current_user.country.id }])
		op_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => op_account.id }])
		Transaction.debit(current_user.id, phone_fr, current_user.account.id, comm_user.id, '', comm_account.id, commission , 'commissionfee-debit')
		Transaction.credit( comm_user.id, '', comm_account.id, current_user.id, phone_fr, current_user.account.id, commission , 'commissionfee-credit')
		User.deduct_balance(current_user.id,commission.to_s)
		User.add_balance(comm_user.id,commission.to_s)
		
		Transaction.debit(current_user.id, phone_fr, current_user.account.id, op_user.id, '', op_account.id, fee , 'transferfee-debit')
		Transaction.credit( op_user.id, '', op_account.id, current_user.id, phone_fr, current_user.account.id, fee , 'transferfee-credit')
		

		User.deduct_balance(current_user.id,fee.to_s)
		User.add_balance(op_user.id,fee.to_s)
		
	    
	    elsif $ENABLE_TRANSFER_FEE == 1
	    
		Rails.logger.info("Transfer - commission fee enabled detected")
		commission = amount.to_f * $FEE
		comm_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Commissions", :c => current_user.country.id }])
		comm_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => comm_account.id }])

		Transaction.debit(current_user.id, phone_fr, current_user.account.id, comm_user.id, '', comm_account.id, commission , 'transferfee-debit')
		Transaction.credit( comm_user.id, '', comm_account.id, current_user.id, phone_fr, current_user.account.id, commission , 'transferfee-credit')
		User.deduct_balance(current_user.id,commission.to_s)
		User.add_balance(comm_user.id,commission.to_s)
	    
	    end
	  end
	

        #send USSD notification
        @int = Interface.find(:all, :conditions => {:screen => 'TRANSFER', :language => 'English'})
        @int.each do |r|
          @h[r.element] = r.text
        end

        ph = UserPhone.find_by_phone_number(request.params['subscriber'])

        @int = Interface.find(:all, :conditions => {:screen => 'TRANSFER', :language => ph.user.language})
        @int.each do |r|
          @h[r.element] = r.text
        end

        am = format( "%.2f", amount.to_f() )
        @sms_msg = URI.escape("#{current_user.surname} (#{phone_fr}) #{@h['TRANSFER_RECEIVED']} #{am} via SlickMoney")
        
	send_sms(phone,@sms_msg)
	#send_ussd(phone,@sms_msg)

          current_user.reload
          @balance = format( "%.2f", current_user.account.balance.to_f() )
          Rails.logger.info("Transactions - Balance after: #{@balance}")
          #@message = "You have successfully transferred #{amount} to #{user_to.surname} at #{phone}"
          @message = "#{@h['TRANSFER_SUCCEEDED']} #{am} #{@h['TRANSFER_RECEIPT']} #{user_to.surname} at #{phone}"
          @h['BALANCE_BALANCE'] = @h['TRANSFER_NEWBALANCE']

          @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => 'English'})
          @int.each do |r|
            @h[r.element] = r.text
          end
 
          @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => current_user.language})
          @int.each do |r|
            @h[r.element] = r.text
          end

          render :action => 'balance' and return

end






   def cashin
      @sess_id = request.cookies['_session_id']
      @balance = current_user.account.balance
      response.headers["Content-Type"] = 'text/xml'
      @h = {}

      @int = Interface.find(:all, :conditions => {:screen => 'CASHIN', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'CASHIN', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

    if request.params['phone_number_to'].nil?
         render :action => 'phonecashin' and return
    end
    
      phone  = request.params['phone_number_to']
      @phone_number_to  = request.params['phone_number_to']
      amount = request.params['amount']
      balance= current_user.account.balance

      unless UserPhone.phone_number_valid?(phone)
        #@message = "Invalid Phone Number"
        @message =  "#{request.params['phone_number_to']} #{@h['CASHIN_ERROR_UNREGISTEREDPHONE']}"
        render :action => 'phonecashin' and return
      end

      if request.params['amount'].nil?
         render :action => 'amountcashin' and return
      end

	
      phone_fr = session[:phone_no] #current_user.phone_numbers
      user_to = UserPhone.find_user(phone)

#      op_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Operating", :c => current_user.country.id }])
#      op_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => op_account.id }])
      
#      comm_account = Account.find(:first, :conditions => [ "account_type = :t and country_id = :c", { :t => "SM Commissions", :c => current_user.country.id }])
#      comm_user    = User.find(:first, :conditions => [ "account_id = :a", { :a => comm_account.id }])

      
      Transaction.transaction do
	Transaction.credit(user_to.id, phone, user_to.account.id, current_user.id, phone_fr, current_user.account.id, amount , 'cashin-credit')

	User.add_balance(user_to.id,amount.to_s)
      end
      #send USSD notification

        ph = UserPhone.find_by_phone_number(phone)

        @int = Interface.find(:all, :conditions => {:screen => 'CASHIN', :language => ph.user.language})
        @int.each do |r|
          @h[r.element] = r.text
        end

        am = format( "%.2f", amount.to_f() )
        @sms_msg = URI.escape("#{am} #{@h['CASHIN_SUCCEEDED']} #{@h['CASHIN_NEWBALANCE']} #{ph.user.account.balance}")
	
	send_sms(phone,@sms_msg)
	#send_ussd(phone,@sms_msg)

          current_user.reload
          @balance = current_user.account.balance
          Rails.logger.info("Cash-IN - Balance after: #{@balance}")
          #@message = "#{@h['TRANSFER_SUCCEEDED']} #{am} #{@h['TRANSFER_RECEIPT']} #{user_to.surname} at #{phone}"
          @h['BALANCE_BALANCE'] = @h['TRANSFER_NEWBALANCE']

          @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => 'English'})
          @int.each do |r|
            @h[r.element] = r.text
          end
 
          @int = Interface.find(:all, :conditions => {:screen => 'BALANCE', :language => current_user.language})
          @int.each do |r|
            @h[r.element] = r.text
          end

          render :action => 'balance' and return

   end



  def password

    response.headers["Content-Type"] = 'text/xml'
    @h = {}
      @int = Interface.find(:all, :conditions => {:screen => 'PASSWORD', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'PASSWORD', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

      render :action => 'password'
  end


  def change_password

    new_password = request.params['password']
    current_user.password=new_password
    current_user.save

    response.headers["Content-Type"] = 'text/xml'

    @h = {}
      @int = Interface.find(:all, :conditions => {:screen => 'PASSWORD', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'PASSWORD', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

    msg = "#{@h['PASSWORD_CHANGED']} #{new_password}"
    
      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => 'English'})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @int = Interface.find(:all, :conditions => {:screen => 'MENU', :language => current_user.language})
      @int.each do |r|
        @h[r.element] = r.text
      end

      @h['MENU_GREETING'] = msg

      render :action => 'menu'
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
