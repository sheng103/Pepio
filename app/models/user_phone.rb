class UserPhone < ActiveRecord::Base
  validates_uniqueness_of :phone_number
  belongs_to :user
  
  def self.find_user(phone_number)
    phone = find_by_phone_number(phone_number)
    return phone.user if phone
    return nil
  end
  
  def self.phone_number_valid?(phone_number)
    phone = find_by_phone_number(phone_number)
    return true if !phone.nil?
    return false
  end
  
  def mark_as_deleted
    self.deleted = true
  end
end
