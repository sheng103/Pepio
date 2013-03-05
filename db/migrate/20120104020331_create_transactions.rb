class CreateTransactions < ActiveRecord::Migration
  def up
    create_table :transactions do |t|
      t.decimal :debit,               :precision => 10, :scale => 2, :default => 0.00
      t.decimal :credit,              :precision => 10, :scale => 2, :default => 0.00
      t.string  :transaction_type,    :null => false,  :limit => 20
      t.integer :user_id,             :null => false
      t.integer :phone_number,        :null => false,  :limit => 9
      t.integer :counter_user_id,     :null => false
      t.integer :counter_phone_number,:null => false,  :limit => 9
      t.boolean :deleted,             :default => false
      
      t.integer :created_by_user_id, :null => false
      t.integer :updated_by_user_id, :null => false
      
      t.timestamps
    end
  end

  def down
    drop_table :trasactions
  end
end
