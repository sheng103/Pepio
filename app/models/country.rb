class Country < ActiveRecord::Base
  validates_presence_of :name, :code
  
  def mark_as_deleted
    self.deleted = true
  end
end
