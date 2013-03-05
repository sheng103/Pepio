class Transaction < ActiveRecord::Base

 belongs_to :user
 belongs_to :counter_user, :class_name =>"User", :foreign_key => "counter_user_id" 
 belongs_to :account
 belongs_to :counter_account, :class_name =>"Account", :foreign_key => "counter_account_id" 
  
  def self.debit(user_id,phone,account_id,c_user_id,c_phone,c_account_id,amount,ttype)
    
    if Transaction.create(:debit               => amount,
                         :credit               => 0.00,
                         :transaction_type     => ttype,
                         :user_id              => user_id,
                         :phone_number         => phone,
                         :account_id           => account_id,
                         :counter_user_id      => c_user_id,
                         :counter_phone_number => c_phone,
                         :counter_account_id   => c_account_id,
                         :created_by_user_id   => user_id,
                         :updated_by_user_id   => 0)
    end
  end
  
  def self.credit(user_id,phone,account_id,c_user_id,c_phone,c_account_id,amount,ttype)
    
    if Transaction.create(:debit               => 0.00,
                         :credit               => amount,
                         :transaction_type     => ttype,
                         :user_id              => user_id,
                         :phone_number         => phone,
                         :account_id           => account_id,
                         :counter_user_id      => c_user_id,
                         :counter_phone_number => c_phone,
                         :counter_account_id   => c_account_id,
                         :created_by_user_id   => user_id,
                         :updated_by_user_id   => 0)
    end
  end

  
  
  def mark_as_deleted
    self.deleted = true
  end
  
  def created_by_user
    return '' if self.created_by_user_id.nil?
    if user = User.find_by_id(created_by_user_id,:select => "email_address")
      user.email_address 
    end
  end
  
  def updated_by_user
    return '' if self.updated_by_user_id.nil?
    if user = User.find_by_id(self.updated_by_user_id,:select => "email_address")
      user.email_address
    end
  end
  
end
