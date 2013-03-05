class CreateInterfaces < ActiveRecord::Migration
  def up
    create_table :interfaces do |t|
      t.string :screen,   :limit => 20, :default => ''
      t.string :element,  :limit => 20, :default => ''
      t.string :language, :limit => 20, :default => ''
      t.string :text,     :limit => 100,:default => ''
      t.boolean :deleted, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :interfaces
  end
end
