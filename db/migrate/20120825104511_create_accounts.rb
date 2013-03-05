class CreateAccounts < ActiveRecord::Migration
  def up
    create_table :accounts do |t|

      t.string  :account_type,  :limit => 30
      t.string  :name,          :limit => 50
      t.integer :company_id,    :null => false
      t.integer :country_id,    :null => false
      t.decimal :balance,       :precision => 10, :scale => 2, :default => 0.00, :null => false
      
      t.boolean :deleted,       :default => false
      t.integer :created_by_user_id
      t.integer :updated_by_user_id
      
      t.timestamps
    end
  end

  def down
    drop_table :accounts
  end
end