class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :email_address, :limit => 30, :unique => true, :null => false
      t.string  :surname,       :limit => 20
      t.string  :first_name,    :limit => 20
      t.string  :second_name,   :limit => 20
      t.string  :language,      :limit => 20
      t.decimal :balance,       :precision => 10, :scale => 2, :default => 0.00, :null => false
      t.string  :user_type,     :limit => 20
      t.boolean :deleted,       :default => false
      
      t.integer :created_by_user_id
      t.integer :updated_by_user_id
      
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
