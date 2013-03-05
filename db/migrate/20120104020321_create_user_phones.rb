class CreateUserPhones < ActiveRecord::Migration
  def up
    create_table :user_phones do |t|
      t.integer :user_id,      :null => false
      t.integer :phone_number, :null => false, :unique => true, :limit => 9
      t.boolean :deleted,      :default => false
      t.timestamps
    end
  end

  def down
    drop_table :user_phones
  end
end
