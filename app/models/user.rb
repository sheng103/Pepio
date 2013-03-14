class User < ActiveRecord::Base
  attr_accessor :password, :avatar
  before_save :encrypt_password
  
  belongs_to :country
  has_many :user_phones
  belongs_to :role
  belongs_to :account
  belongs_to :company
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :mini => '50x50' }
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :country, :first_name, :surname, :role 
  #validates_presence_of :email_address
  #validates_uniqueness_of :email_address
  validates :gender, :length => { :maximum => 10 }
  validates :shopkepper, :length => { :maximum => 10 }
  
  def self.authenticate(phone_number, password)  
    phone = UserPhone.find_by_phone_number(phone_number)
    if phone
      user  = phone.user
      if  !user.deleted && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user  
      else  
        nil
      end
    end  
  end
  
  def self.authenticate_admin(email_address, password)  
    user = find_by_email_address(email_address)  
    if !user.deleted && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && (user.role.code<500)
      user  
    else  
      nil  
    end  
  end  
  
  def self.deduct_balance(user_id,amount)
    return false if !exists?(user_id)
    if user = find_by_id(user_id)
      user.account.balance = user.account.balance - BigDecimal.new(amount)
      user.account.save
    end
  end
  
  def self.add_balance(user_id,amount)
    return false if !exists?(user_id)
    if user = find_by_id(user_id)
      user.account.balance = user.account.balance + BigDecimal.new(amount)
      user.account.save
    end
  end
  
  def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
  end  
  
  def is_admin?
    return false if self.role.code.nil?
    if self.role.code < 400
      return true
    else
      return false
    end
  end
  
  def mark_as_deleted
    self.deleted = true
  end
  
  def created_by_user
    return '' if self.created_by_user_id.nil?
    User.find_by_id(created_by_user_id,:select => "email_address").email_address
  end
  
  def updated_by_user
    return '' if self.updated_by_user_id.nil?
    User.find_by_id(self.updated_by_user_id,:select => "email_address").email_address
  end
  
  def phone_numbers
    self.user_phones
  end
end
