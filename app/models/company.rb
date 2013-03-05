class Company < ActiveRecord::Base
  validates_presence_of :name, :country
  belongs_to :country
  belongs_to :account
    
  def mark_as_deleted
    self.deleted = true
  end
end
