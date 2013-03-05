class Account < ActiveRecord::Base
  validates_presence_of :name, :country
  
  belongs_to :country
  belongs_to :company

  
  def self.deduct_balance(account_id,amount)
    return false if !exists?(account_id)
    if account = find_by_id(account_id)
      account.balance = account.balance - BigDecimal.new(amount)
      account.save
    end
  end
  
  def mark_as_deleted
    self.deleted = true
  end
  
  def combined_value
  "#{self.name} - #{self.id} - #{self.country.name}"
  end
    
  
end
