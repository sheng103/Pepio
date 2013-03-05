class Interface < ActiveRecord::Base
  validates_presence_of :screen, :element
  
  def mark_as_deleted
    self.deleted = true
  end
end
